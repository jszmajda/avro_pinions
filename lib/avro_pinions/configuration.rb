require 'singleton'

module AvroPinions
  class Configuration
    include Singleton

    attr_accessor :publisher, :schema_registry, :wire_format

    def initialize
    end

    def publisher=(pub)
      unless pub.respond_to?(:publish) && pub.method(:publish).arity == 2
        raise InvalidConfiguration.new("Please define a publisher that responds to publish and receives a topic and message")
      end
      @publisher = pub
    end

    # :type gets pulled off and constructs the given registy
    # all of the rest of the options get passed to an instance of hte type.kklk
    def schema_registry=(options = {})
      klass = options.delete(:type).to_s.split(/_/).map(&:capitalize).join
      const = Object.const_get("AvroPinions::#{klass}Registry")
      sr = const.new(options)
      @schema_registry = sr
    end

    def wire_format=(format)
      unless AvroPinions::Codec::SUPPORTED_WIRE_FORMATS.include?(format)
        raise InvalidConfiguration.new("Please supply a valid wire format. Valid options are: #{AvroPinions::Codec::SUPPORTED_WIRE_FORMATS}")
      end

      @wire_format = format
    end

    class InvalidConfiguration < StandardError
    end
  end
end
