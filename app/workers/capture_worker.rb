class CaptureWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false, :backtrace => true
  
  def perform(id, count)
    c = Capture.find_by_id(id)
    if c
      c.start!
      c.start_recording
    end
  end
end
