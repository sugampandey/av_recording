json.array!(@schedules) do |schedule|
  json.extract! schedule, :wday, :start_time, :end_time, :enabled
  json.url schedule_url(schedule, format: :json)
end
