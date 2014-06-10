require 'pathname'
require 'hashie'
require 'json'

dir = Pathname(__FILE__).parent.parent
$:.unshift(dir) unless $:.include?(dir)

require 'bebot/config/env'
