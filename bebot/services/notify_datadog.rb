require 'bebot/config'
require 'bebot/models/comparator'
require 'dogapi'

module Bebot
  module Services
    class NotifyDatadog
      attr_reader :client

      def initialize(comparator)
        @client = Dogapi::Client.new(ENV.fetch('DATADOG_TOKEN'))
        @comparator = comparator
      end

      def run
        dog_repo = @comparator.repo.tr('/','.').downcase
        client.emit_point(
          'bebot.commits',
          @comparator.commits,
          tags: ["repo:#{dog_repo}"]
        )
        client.emit_point(
          'bebot.staleness',
          @comparator.staleness,
          tags: ["repo:#{dog_repo}"]
        )
        nil
      end
    end
  end
end

