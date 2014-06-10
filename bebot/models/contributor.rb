module Bebot
  module Models
    class Contributor
      include Comparable

      attr_reader :login, :name, :gravatar_id

      def initialize(options = nil)
        options ||= {}
        @login       = options['login']
        @name        = options['name']
        @gravatar_id = options['gravatar_id']
      end

      def gravatar_url
        "http://www.gravatar.com/avatar/#{gravatar_id}?s=200&d=retro"
      end

      def <=>(other)
        self.login <=> other.login
      end

      def eql?(other)
        self == other
      end

      def hash
        login.hash
      end

    end
  end
end
