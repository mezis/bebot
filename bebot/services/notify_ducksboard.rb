require 'bebot/config'
require 'httparty'

module Bebot
  module Services
    class NotifyDucksboard
      def initialize(comparator)
        @comparator = comparator
      end

      def run
        _post _slots['staleness'],  value: @comparator.staleness
        _post _slots['undeployed'], value: @comparator.pull_requests

        0.upto(2) do |index|
          payload = if contributor = @comparator.contributors[index]
            { value: { source: contributor.gravatar_url, caption: nil } }
          else
            { value: { source: '', caption: nil } }
          end
          _post _slots['contributors'][index], payload
        end

        staleness_check = if @comparator.staleness < 4
          0 # OK
        elsif @comparator.staleness < 24
          2 # WARNING
        else
          1 # FAIL
        end

        _post _slots['stale'], value: staleness_check
      end

      private

      def _post(slot, data)
        endpoint = "https://push.ducksboard.com/v/#{slot}"
        response = HTTParty.post(
          endpoint, 
          body:       data.to_json,
          basic_auth: { 
            username: ENV.fetch('DUCKS_API_TOKEN'),
            password: 'unused'
          })

        $stderr.puts ">> #{endpoint}"
        $stderr.puts ">> #{data.to_json}"
        $stderr.puts response.inspect
      end

      def _slots
        @_slots ||= JSON.parse(ENV.fetch('DUCKS_SLOTS'))
      end
    end
  end
end

