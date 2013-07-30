require 'pathname'

module Bebot
  def self.root
    @root ||= Pathname(__FILE__).parent
  end

  def self.view_path
    @view_path ||= root.join('views')
  end
end