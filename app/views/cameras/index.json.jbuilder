json.array!(@cameras) do |camera|
  json.extract! camera, :host_uri, :capture_path, :username, :password
  json.url camera_url(camera, format: :json)
end
