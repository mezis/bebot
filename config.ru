require 'rack'
require 'uri'

if ENV['NEW_RELIC_LICENSE_KEY']
  require 'newrelic_rpm'
  use NewRelic::Rack::AgentHooks
end

icon_url = ENV.fetch('ICON_URL', nil)
unless icon_url.nil?
  uri = URI.parse(icon_url)
  map uri.path do
    run Rack::File.new(".#{uri.path}")
  end
end

map "/ping" do
  run ->(env) { [ 200, {}, ['pong'] ] }
end