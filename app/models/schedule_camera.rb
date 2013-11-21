class ScheduleCamera < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :camera
end
