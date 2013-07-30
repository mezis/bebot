require 'pathname'

dir = Pathname(__FILE__).parent
$:.unshift(dir) unless $:.include?(dir)

require 'bebot/application'
run Bebot::Application
