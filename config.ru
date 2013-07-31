require 'pathname'

dir = Pathname(__FILE__).parent
$:.unshift(dir) unless $:.include?(dir)

require 'newrelic_rpm'
require 'bebot/application'
run Bebot::Application
