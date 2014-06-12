require 'business_time'
require 'bebot/config/env'

def Time.set_zone
  self.zone = ENV.fetch('BEBOT_TIMEZONE', 'Europe/London')
end

Time.set_zone
BusinessTime::Config.beginning_of_workday = "9 am"
BusinessTime::Config.end_of_workday       = "6 pm"

