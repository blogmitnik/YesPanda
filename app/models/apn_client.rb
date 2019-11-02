class APNClient < Houston::Client
 
  def initialize(cert)
    @gateway_uri = Houston::Client.development.gateway_uri
    @feedback_uri = Houston::Client.development.feedback_uri
    @certificate = File.read(ENV['APPLE_CERTIFICATE']) #certificate from prerequisites
    @timeout = Float(ENV['APN_TIMEOUT'] || 0.5)
  end
 
  def self.apple_feedback()
    APNClient.new(ENV['APPLE_CERTIFICATE']).devices.each do |uuid|
      device = Device.find_by_uuid(uuid)
      device.destroy unless device.nil?
    end
  end
end