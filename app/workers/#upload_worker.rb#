class UploadWorker
  include Sidekiq::Worker
  sidekiq_options :retry => true, :backtrace => true
  
  def perform(id, count)
    c = Capture.find_by_id(id)
    if c
      c.upload! 
      c.process_upload
    end
  end
end
