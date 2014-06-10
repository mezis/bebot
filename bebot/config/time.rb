require 'business_time'
require 'bebot/config/env'

Time.zone = ENV.fetch('BEBOT_TIMEZONE', 'Europe/London')

BusinessTime::Config.beginning_of_workday = "9 am"
BusinessTime::Config.end_of_workday       = "6 pm"

