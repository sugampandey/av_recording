class Capture < ActiveRecord::Base
  belongs_to :camera
    
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
    
    # after_transition :on => :start, :do => :process_capture
    # after_transition :on => :upload, :do => :process_upload
  end 
  
  validate :verify_times_on_create, :on => :create
  validate :verify_worker_not_started, :on => :update
  validate :verify_times_on_update, :on => :update
  
  after_create :register_capture_worker
  after_update :update_capture_worker
   
  def duration
    seconds = self.end_time - self.start_time 
    seconds.abs
  end
  
  def output_filename
    date_part = ['Video', 
      self.start_time.strftime("%m%d%Y")
    ].join('_')
    
    time_part = [ self.start_time.strftime("%H%M"),
      self.end_time.strftime("%H%M"),
      self.id
    ].join('-')
    
    camera_part = self.camera.name.parameterize
    
    "#{date_part}_#{time_part}_#{camera_part}"
  end
  
  def output_file_path
    f = output_filename
    if Rails.env.production?
      "/mnt/#{self.id}-#{f}.avi"
    else
      "#{Rails.root}/tmp/cache/#{self.id}-#{f}.avi"
    end
  end
  
  def remove_output_file
    File.delete(self.output_file_path) if File.exist?(self.output_file_path)
  end

  def worker_started?
    w = Sidekiq::SortedSet.new('schedule').find_job(self.job_id)
    return w.nil?
  end
  
  def update_capture_worker
    if self.start_time_changed? or self.end_time_changed?
      unless worker_started?
        w = Sidekiq::SortedSet.new('schedule').find_job(self.worker_id)
        w.delete if w
        register_capture_worker
      end
    end
  end
  
  def register_capture_worker
    jid = CaptureWorker.perform_at(self.start_time, self.id, 1)
    Capture.where(id: self.id).update_all({ job_id: jid })
  end
  
  def register_upload_worker
    perform_at = self.end_time# + 5.minutes
    jid = UploadWorker.perform_at(perform_at, self.id, 1)
    Capture.where(id: self.id).update_all({ job_id: jid })
  end
  
  # save pid and register new uploading job
  def process_capture
    url = self.camera.stream_uri
    result = system "sh #{Rails.root}/bin/capture.sh '#{url}' #{self.duration} #{self.output_file_path}"
    self.pid = result
    if self.save! 
      register_upload_worker
    end
  end
  
  def process_upload
    s3 = AWS::S3.new(
      :access_key_id => 'AKIAJN2HHO3S5WORO7LA',
      :secret_access_key => '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'
    )
    bucket_name = "AV_Recording"

    key = File.basename(self.output_file_path)
    s3.buckets[bucket_name].objects[key].write(:file => self.output_file_path)
    self.complete!
  end
  
  def verify_worker_not_started
    if worker_started? and (self.start_time_changed? or self.end_time_changed?)
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

end
