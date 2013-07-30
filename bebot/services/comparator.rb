require 'bebot/config'
require 'bebot/models/contributor'

module Bebot::Services
  class Comparator
    attr_reader :client, :repo, :from, :to

    def initialize(client:nil, repo:nil, from:'master', to:'production')
      @client = client
      @repo   = repo
      @from   = from
      @to     = to
    end

    def contributors
      @contributors ||= _comparison.commits
        .group_by { |c| Bebot::Models::Contributor.new(c.author) }
        .map { |contributor,commits| [contributor, commits.length] }
        .sort { |a,b| b.last <=> a.last }
        .map(&:first)
    end

    def commits
      _comparison.commits.length
    end

    def staleness
      return 0 if _oldest_timestamp.nil?

      now = DateTime.now.to_time.utc
      old = DateTime.parse(_oldest_timestamp).to_time.utc
      now - old
    end

    private

    def _oldest_timestamp
      @oldest_timestamp ||= _comparison.commits
        .map { |payload| payload.commit.author.date }
        .min
    end

    def _comparison
      @_comparison ||= client.compare(repo, from, to)
    end
  end
end

