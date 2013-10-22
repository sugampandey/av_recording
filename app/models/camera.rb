class Camera < ActiveRecord::Base

  validates :name, :presence => true
  validates :host_uri, :presence => true

  def stream_uri
    url = "#{self.host_uri}#{self.capture_path}"
    
    url.gsub!(/:username/, self.username)
    url.gsub!(/:password/, self.password)
    
    url
  end
  
end
