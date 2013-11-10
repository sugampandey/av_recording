class Capture < ActiveRecord::Base
  belongs_to :camera
  
  has_attached_file :video
    #,
    #:path           => "videos/:id/:basename.:extension",
    #:storage        => :s3,
    #:s3_permissions => :private,
    #:s3_credentials => "#{Rails.root}/config/s3.yml"
  
  validates :start_time, :presence => true
  validates :end_time, :presence => true
  validates :time_zone, :presence => true
  validates :camera_id, :presence => true
  
  state_machine :state, :initial => :pending do
    state :pending
    state :recording
    state :uploading
    state :completed
    
    event :start do
      transition all => [:recording]
    end
    
    event :upload do
      transition all => [:uploading]
    end    
    
    event :complete do
      transition all =>  [:completed]
    end
  end 
  
  validate :verify_times_on_create, :on => :create
  validate :verify_job_not_started, :on => :update
  validate :verify_times_on_update, :on => :update
  
  after_create do
    self.post_record_job
  end
  after_update :register_new_job
   
  def duration
    seconds = self.end_time - self.start_time 
    seconds.abs
  end
  
  def start_recording
    if process_recording
      self.upload!
      self.save_attachment
    end
  end
  
  def output_file_path
    f = self.start_time.to_s.parameterize
    "#{Rails.root}/tmp/cache/#{self.id}-#{f}.avi"
  end

  def save_attachment
    self.video = File.open(self.output_file_path, 'rb')
    if self.save!
      self.complete!
      self.remove_output_file
    end
  end
  
  def remove_output_file
    File.delete(self.output_file_path) if File.exist?(self.output_file_path)
  end
  
  def register_new_job
    if self.start_time_changed? or self.end_time_changed?
      unless job_started
        w = Sidekiq::SortedSet.new('schedule').find_job(self.job_id)
        w.delete if w
        post_record_job
      end
    end
  end
  
  def post_record_job
    jid = CaptureWorker.perform_at(self.start_time, self.id, 1)
    Capture.where(id: self.id).update_all({ job_id: jid })
  end
  
  def job_started
    w = Sidekiq::SortedSet.new('schedule').find_job(self.job_id)
    return w.nil?
  end
  
  def verify_job_not_started
    if job_started and (self.start_time_changed? or self.end_time_changed?)
      self.errors.add(:base, "Capture process already started")
    end
  end
  
  def verify_times_on_create
    if self.start_time < Time.now
      self.errors.add(:start_time, "Capture must be started in the future")
    end
    
    if self.end_time < Time.now
      self.errors.add(:end_time, "Capture must be ended in the future")
    end
    
  end
  
  def verify_times_on_update
    
    if self.start_time >= self.end_time
      self.errors.add(:end_time, "Start time must be less than end time")
    end
    
    if self.end_time <= self.start_time
      self.errors.add(:end_time, "Start time must be greather than end time")
    end
  end
  
  def process_recording
    self.remove_output_file
    url = self.camera.stream_uri
    opt = "-acodec libmp3lame -t #{self.duration} #{self.output_file_path}"
    
    Rails.logger.info "[INFO] avconv -i '#{url}' #{opt}"
    result = system "avconv -i '#{url}' #{opt}"
    
    return result
  end

end
