json.array!(@captures) do |capture|
  json.extract! capture, :start_time, :end_time, :state
  json.url capture_url(capture, format: :json)
end
