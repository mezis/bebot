ENV['RACK_ENV'] ||= 'test'

require 'pathname'
require 'hashie'
require 'json'
require 'pry'

dir = Pathname(__FILE__).parent.parent
$:.unshift(dir) unless $:.include?(dir)

require 'bebot/config/env'
