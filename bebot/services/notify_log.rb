module Bebot
  module Services
    class NotifyLog
      def initialize(comparator)
        @comparator = comparator
      end

      def run
        $stderr.puts "repo:#{@comparator.repo} from:#{@comparator.from} to:#{@comparator.to} staleness:#{@comparator.staleness}"
      end
    end
  end
end
