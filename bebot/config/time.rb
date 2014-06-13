require 'business_time'
require 'bebot/config/env'

module Bebot
  module_function def time_zone
    ENV.fetch('BEBOT_TIMEZONE', 'Europe/London')
  end
end

BusinessTime::Config.beginning_of_workday = "9 am"
BusinessTime::Config.end_of_workday       = "6 pm"

