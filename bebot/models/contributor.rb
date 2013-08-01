require 'bebot/config'

module Bebot::Models
  class Contributor
    include Comparable

    attr_reader :login, :gravatar_id

    def initialize(options = nil)
      options ||= {}
      @login       = options.fetch('login', 'unknown')
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
