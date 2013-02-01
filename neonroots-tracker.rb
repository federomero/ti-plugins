# Ti plugin that posts time to the NeonRoots Time Tracker
#
# Loads email and password from env variable NRTT_EMAIL and NRTT_PASS
# or asks for them in case they are not set
#
# If NRTT_PREFIX env variable is set, it will only ask to log time
# for projects with the format: $NRTT_PREFIX:project
# dropping the prefix
#
# Example:
#
#   # NRTT_PREFIX not set
#   ti SomeProject Task description
#
#   This will assigned the time the project named 'SomeProject'
#
#   export NRTT_PREFIX=NeonRoots
#   ti NeonRoots:SomeProject Task description
#
#   This will assigned the time the project named 'SomeProject'
#


require 'net/http'
require 'highline/import'
require 'json'

class NRTTClient

  attr_accessor :email, :password

  def initialize(email, password)
    self.email    = email
    self.password = password
  end

  def host
    'nr-tt.herokuapp.com'
  end

  def uri
    URI("http://#{host}/api/tracktime")
  end

  def post_time (minutes, project, description, start_time)

    data = {
      project:          project,
      description:      description,
      minutes:          minutes,
      created_at:       start_time.strftime("%Y-%m-%d %H:%M"),
      user_auth_email:  email,
      user_auth_pass:   password,
    }
    # puts data.inspect

    Net::HTTP.post_form(uri, data )

  end
end

if ENV['NRTT_PREFIX']
  timer = Ti::Timer
  timer.on :finish do

    if prefix = ENV['NRTT_PREFIX']
      client, project, _ = timer.project.split(':')
      next if client != prefix
    else
      project, _ = timer.project.split(':')
    end

    if agree('Do you want to submit your hours to the NeonTracker now? Y/n')
      email = ENV['NRTT_EMAIL'] || ask('Email:')
      pass  = ENV['NRTT_PASS']  || ask('Password (will not be shown):'){|q| q.echo = false}
      tracker = NRTTClient.new(email, pass)
      response = JSON.parse(tracker.post_time(timer.minutes, project, timer.task, timer.start_time).body)
      puts "#{response['response']}: #{response['message']}"
    end
  end
end
