class Capture < ActiveRecord::Base
  belongs_to :camera
  
  has_attached_file :video,
    :path           => "videos/:id/:basename.:extension",
    :storage        => :s3,
    :s3_permissions => :private,
    :s3_credentials => "#{Rails.root}/config/s3.yml"
  
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
    
    #after_transition :on => :enqueue, :do => :post_record_job
    #after_transition :on => :upload, :do => :save_attachment
    #after_transition :on => :start, :do => :start_recording
    #after_transition :on => :complete, :do => :remove_output_file
  end 
  
  after_create do
    self.post_record_job
  end
   
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
  
  def post_record_job
    Delayed::Job.enqueue(CaptureJob.new(self.id), { :run_at => self.start_time })
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
