require 'pathname'
require 'hashie'
require 'json'
require 'timecop'

dir = Pathname(__FILE__).parent.parent
$:.unshift(dir) unless $:.include?(dir)

require 'bebot/config'
Dotenv.load

RSpec.configure do |config|
  ENV['GITHUB_TOKEN']   = 'github_token'
  ENV['GITHUB_LOGIN']   = 'github_login'
  ENV['DATADOG_TOKEN']  = 'dd_token'
  ENV['DUCKS_SLOTS']    = '{"staleness":123,"stale":234,"undeployed":345,"contributors":[456,567,678]}'
  ENV['DUCKS_API_TOKEN']= 'foob4r'
  ENV['RACK_ENV']       = 'test'
end

