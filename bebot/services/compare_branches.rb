require 'bebot/config'
require 'bebot/models/comparator'
require 'bebot/services/notify_datadog'
require 'bebot/services/notify_ducksboard'
require 'bebot/services/notify_log'
require 'octokit'

module Bebot::Services
  class CompareBranches
    attr_reader :client, :repo, :from, :to

    def initialize(repo:nil, from:'master', to:'production')
      @client = client
      @repo   = repo
      @from   = from
      @to     = to
    end

    def run
      client = Octokit::Client.new(
        login:       ENV['GITHUB_LOGIN'], 
        oauth_token: ENV['GITHUB_TOKEN'])

      comparator = Bebot::Models::Comparator.new(
          client: client,
          repo:   repo,
          from:   from,
          to:     to)

      NotifyDatadog.new(comparator).run

      # Disabled pending tests
      # NotifyDucksboard.new(comparator).run
      
      NotifyLog.new(comparator).run

      {
        staleness:    comparator.staleness,
        contributors: comparator.contributors
      }
    end
  end
end

