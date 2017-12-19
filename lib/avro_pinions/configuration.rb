require 'singleton'

module AvroPinions
  class Configuration
    include Singleton

    attr_accessor :publisher

    def initialize
    end

    def publisher=(pub)
      unless pub.respond_to?(:publish) && pub.method(:publish).arity == 2
        raise InvalidPublisher.new("Please define a publisher that responds to publish and receives a topic and message")
      end
      @publisher = pub
    end

    class InvalidPublisher < StandardError
    end
  end
end
