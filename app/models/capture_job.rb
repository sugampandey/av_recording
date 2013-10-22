class CaptureJob < Struct.new(:capture_id)
  def perform
    run_in_thread do
      c = Capture.find_by_id(capture_id)
      if c
        c.start!
        c.start_recording
      end
    end
  end
  
  def run_in_thread(&block)
    Thread.new do
      yield
      ActiveRecord::Base.connection.close
    end
  end
end
