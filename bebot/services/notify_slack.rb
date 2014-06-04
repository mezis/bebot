require 'bebot/config'
require 'slack-notifier'
require 'tzinfo'

module Bebot
  module Services
    class NotifySlack
      def initialize(comparator)
        @comparator = comparator
      end

      def run
        # abort if not stale enough
        return unless @comparator.staleness > 6

        # abort if outside valid deploy hours
        now = TZInfo::Timezone.get('Europe/London').now
        return unless (1..5).include?(now.wday)   # week days
        return unless (9..16).include?(now.hour)  # 9am to 5pm

        notifier = Slack::Notifier.new(
          ENV.fetch('SLACK_TEAM'), ENV.fetch('SLACK_TOKEN'),
          channel:  ENV.fetch('SLACK_CHANNEL'),
          username: ENV.fetch('SLACK_USERNAME')
        )

        notifier.ping [
          "Hi team!",
          "There are #{@comparator.commits} commits in #{@comparator.pull_requests} pull requests waiting to be deployed; the oldest merge is #{@comparator.staleness.round} hours old.",
          "#{login_list} should probably prepare a deploy!"
        ].join("\n")
      end

      private

      def login_list
        logins = @comparator.contributors.map(&:login)

        case logins.length
        when 0
          raise ArgumentError
        when 1
          logins.join
        when 2
          "#{logins[0]} or #{logins[1]}"
        else
          "#{logins[0...-1].join(', ')} or #{logins[-1]}"
        end
      end
    end
  end
end
