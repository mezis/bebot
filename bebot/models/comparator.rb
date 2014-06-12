require 'bebot/config/time'
require 'bebot/models/contributor'

module Bebot
  module Models
    class Comparator
      attr_reader :client, :repo, :from, :to

      def initialize(client:nil, repo:nil, from:'master', to:'production')
        @client = client
        @repo   = repo
        @from   = from
        @to     = to
      end

      def contributors
        @contributors ||= _real_commits
          .group_by { |c| Bebot::Models::Contributor.new(c.author) }
          .map { |contributor,commits| [contributor, commits.length] }
          .sort { |a,b| b.last <=> a.last }
          .map(&:first)
      end

      def commits
        _comparison.commits.length
      end

      def pull_requests
        @pull_requests ||= _merge_commits.length
      end

      def staleness
        return 0 if _oldest_timestamp.nil?

        puts "  oldest timestamp: #{_oldest_timestamp.inspect}"
        puts "  now: #{Time.current.inspect}"
        puts "  zone: #{Time.zone}"
        _oldest_timestamp.business_time_until(Time.current) / 3_600
      end

      private

      def _real_commits
        _comparison.commits - _merge_commits
      end

      def _merge_commits
        _comparison.commits
          .select { |payload| payload.commit.message =~ /^Merge pull request/ }
      end

      def _oldest_timestamp
        @oldest_timestamp ||= _merge_commits
          .map { |payload| payload.commit.author.date }
          .min
      end

      def _comparison
        @_comparison ||= client.compare(repo, to, from)
      end
    end
  end
end
