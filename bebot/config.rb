require 'pathname'
require 'dotenv'

Dotenv.overload '.env.local'

module Bebot
  def self.root
    @root ||= Pathname(__FILE__).parent
  end

  def self.view_path
    @view_path ||= root.join('views')
  end
end
