require 'pathname'
require 'hashie'
require 'json'
require 'timecop'
require 'sinatra'
require 'rack/test'

dir = Pathname(__FILE__).parent.parent
$:.unshift(dir) unless $:.include?(dir)

require 'bebot/config'

# setup test sinatra environment
set :environment,  :test
set :run,          false
set :raise_errors, true
set :logging,      false

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

ENV['GITHUB_TOKEN']   = 'github_token'
ENV['GITHUB_LOGIN']   = 'github_login'
ENV['DATADOG_TOKEN']  = 'dd_token'
ENV['RACK_ENV']       = 'test'