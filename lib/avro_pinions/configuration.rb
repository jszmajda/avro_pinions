require 'singleton'

module AvroPinions
  class Configuration
    include Singleton

    attr_accessor :publisher, :schema_registry

    def initialize
    end

    def publisher=(pub)
      unless pub.respond_to?(:publish) && pub.method(:publish).arity == 2
        raise InvalidPublisher.new("Please define a publisher that responds to publish and receives a topic and message")
      end
      @publisher = pub
    end

    # :type gets pulled off and constructs the given registy
    # all of the rest of the options get passed to an instance of hte type.kklk
    def schema_registry_options=(options = {})
      klass = options.delete(:type).to_s.split(/_/).map(&:capitalize).join
      const = Object.const_get("AvroPinions::#{klass}Registry")
      sr = const.new(options)
      @schema_registry = sr
    end

    class InvalidPublisher < StandardError
    end
  end
end
