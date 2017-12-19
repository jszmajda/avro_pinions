require 'singleton'

module AvroPinions
  class Configuration
    include Singleton

    attr_accessor :publisher

    def initialize
    end
  end
end
