require 'bebot/config/env'
require 'bebot/models/comparator'
require 'bebot/services/notify_datadog'
require 'bebot/services/notify_ducksboard'
require 'bebot/services/notify_log'
require 'bebot/services/notify_slack'
require 'octokit'

module Bebot
  module Services
    class CompareBranches
      attr_reader :client, :repo, :from, :to

      def initialize(repo:nil, from:'master', to:'production', notify: %w(log))
        @repo   = repo
        @from   = from
        @to     = to
        @notify = notify
      end

      def run
        @client = Octokit::Client.new(
          access_token: ENV.fetch('GITHUB_TOKEN'))

        comparator = Bebot::Models::Comparator.new(
            client: @client,
            repo:   repo,
            from:   from,
            to:     to)

        @notify.each do |target|
          Bebot::Services.const_get("Notify#{target.capitalize}").new(comparator).run
        end


        # Disabled pending tests
        # NotifyDucksboard.new(comparator).run
        

        {
          staleness:     comparator.staleness,
          pull_requests: comparator.pull_requests,
          contributors:  comparator.contributors
        }
      end
    end
  end
end
