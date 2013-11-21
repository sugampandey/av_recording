class Schedule < ActiveRecord::Base
  has_many :schedule_cameras, :dependent => :destroy
  has_many :cameras, :through => :schedule_cameras
  
  validates :wday, :presence => true
  validates :wday, :uniqueness => true
  validates :start_time, :presence => true
  validates :end_time, :presence => true
  validate :required_cameras
  
  def required_cameras
    if self.schedule_cameras.size < 1
      errors.add(:base, "Please select camera")
    end
  end
  
  def self.register
    sch_date = Time.zone.now + 1.day
    sch_date
    sch = Schedule.where(:wday => sch_date.wday, :enabled => true).first
    if sch
      sch_start_time = "#{sch_date.strftime('%Y-%m-%d')} #{sch.start_time.strftime('%H:%M')}"
      sch_end_time = "#{sch_date.strftime('%Y-%m-%d')} #{sch.end_time.strftime('%H:%M')}"
      
      sch.cameras.each do |cam|
        capture = Capture.new
        capture.time_zone = Time.zone.name
        capture.start_time = sch_start_time
        capture.end_time = sch_end_time
        capture.camera = cam
        capture.save!
      end
      
      nil
    end
    nil
  end
  
end
