require 'sinatra/base'
require 'bebot/services/comparator'
require 'octokit'
require 'dogapi'
require 'yajl'

module Bebot::Controllers
  class Comparator < Sinatra::Base
    set :views, Bebot.view_path

    get '/compare/:org/:repo/:from...:to' do
      client = Octokit::Client.new(
        login:       ENV['GITHUB_LOGIN'], 
        oauth_token: ENV['GITHUB_TOKEN'])

      comparator = Bebot::Services::Comparator.new(
          client: client,
          repo:   "#{params['org']}/#{params['repo']}",
          from:   params['from'],
          to:     params['to'])

      dog_client = Dogapi::Client.new(ENV['DATADOG_TOKEN'])
      dog_repo   = comparator.repo.tr('/','.').downcase
      dog_client.emit_point "bebot.#{dog_repo}.commits",   comparator.commits,   tags:['bebot-commits']
      dog_client.emit_point "bebot.#{dog_repo}.staleness", comparator.staleness, tags:['bebot-staleness']

      yajl :comparator, locals:{ comparator:comparator }
    end
  end
end
