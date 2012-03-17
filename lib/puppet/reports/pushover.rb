require 'puppet'
require 'net/https'
require 'uri'
require 'yaml'

unless Puppet.version.to_i >= '2.6.5'.to_i
  fail "This report processor requires Puppet version 2.6.5 or later"
end

Puppet::Reports.register_report(:pushover) do

  configfile = File.join([File.dirname(Puppet.settings[:config]), "pushover.yaml"])
  raise(Puppet::ParseError, "Pushover report config file #{configfile} not readable") unless File.exist?(configfile)
  @config = YAML.load_file(configfile)
  USERKEY = @config[:userkey]
  APIKEY  = "oCuifGPabyVxBzlfgWOw1WgYfN5ODH"

  desc <<-DESC
  Send notification of failed reports to Pushover.
  DESC

  def process
    if self.status == 'failed'
      message = "Puppet run for #{self.host} #{self.status} at #{Time.now.asctime}."

      begin
        timeout(8) do
          Puppet.debug "Sending status for #{self.host} to Pushover."
          url = URI.parse("https://api.pushover.net/1/messages")
          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          request = Net::HTTP::Post.new(url.request_uri)
          request.set_form_data({
            :token    => APIKEY,
            :user     => USERKEY,
            :title    => 'Puppet',
            :message  => message
          })
          response = http.request(request)
        end
      rescue Timeout::Error
         Puppet.error "Failed to send report to Pushover retrying..."
         max_attempts -= 1
         retry if max_attempts > 0
      end
    end
  end
end
