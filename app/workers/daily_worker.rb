class DailyWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options :retry => false, :backtrace => true
  
  recurrence backfill: true do
    daily
  end

  def perform
    puts "Test"
  end
end
