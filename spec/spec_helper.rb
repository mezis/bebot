require 'pathname'
require 'hashie'
require 'json'
require 'timecop'

dir = Pathname(__FILE__).parent.parent
$:.unshift(dir) unless $:.include?(dir)

require 'bebot/config'

RSpec.configure do |config|
  ENV['GITHUB_TOKEN']   = 'github_token'
  ENV['GITHUB_LOGIN']   = 'github_login'
  ENV['DATADOG_TOKEN']  = 'dd_token'
  ENV['RACK_ENV']       = 'test'
end

