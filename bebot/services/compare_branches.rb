require 'bebot/config'
require 'bebot/models/comparator'
require 'octokit'
require 'dogapi'

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

      DatadogNotifier.new.run(comparator)
      DucksboardNotifier.new.run(comparator)
      LogNotifier.new.run(comparator)

      {
        staleness: comparator.staleness,
        contributors: comparator.contributors
      }
    end

    private

    class DatadogNotifier
      attr_reader :client

      def initialize
        @client = Dogapi::Client.new(ENV['DATADOG_TOKEN'])
      end

      def run(comparator)
        dog_repo = comparator.repo.tr('/','.').downcase
        client.emit_point "bebot.#{dog_repo}.commits",   comparator.commits,   tags:['bebot-commits']
        client.emit_point "bebot.#{dog_repo}.staleness", comparator.staleness, tags:['bebot-staleness']
        nil
      end
    end

    class DucksboardNotifier
      def initialize
      end

      def run(comparator)
        nil
      end
    end

    class LogNotifier
      def initialize
      end

      def run(comparator)
        $stderr.puts "repo:#{comparator.repo} from:#{comparator.from} to:#{comparator.to} staleness:#{comparator.staleness}"
      end
    end
  end
end

