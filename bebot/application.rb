require 'sinatra/base'
require 'bebot/config'
require 'bebot/controllers/comparator'

module Bebot
  class Application < Sinatra::Base
    use Controllers::Comparator
  end
end