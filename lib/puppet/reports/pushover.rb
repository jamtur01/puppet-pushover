require 'puppet'
require 'yaml'
require 'json'

unless Puppet.version >= '2.6.5'
  fail "This report processor requires Puppet version 2.6.5 or later"
end

Puppet::Reports.register_report(:pushover) do

  configfile = File.join([File.dirname(Puppet.settings[:config]), "pushover.yaml"])
  raise(Puppet::ParseError, "Pushover report config file #{configfile} not readable") unless File.exist?(configfile)
  @config = YAML.load_file(configfile)

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
          req = Net::HTTP::Post.new(url.path)
          req.set_form_data({
            :token => @config[:apikey],
            :user  => @config[:userkey],
            :message => message
          })
          res = Net::HTTP.new(url.host, url.port)
          res.use_ssl = true
          res.verify_mode = OpenSSL::SSL::VERIFY_NONE
          res.start {|http| http.request(req) }
        end
      rescue Timeout::Error
         Puppet.error "Failed to send report to Pushover retrying..."
         max_attempts -= 1
         retry if max_attempts > 0
      end
    end
  end
end
