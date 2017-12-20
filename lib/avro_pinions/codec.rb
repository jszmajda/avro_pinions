module AvroPinions
  class Codec
    attr_accessor :schema
    def initialize(schema_name:, namespace:)
      @schema = AvroPinions.schema_registry.schema(schema_name, namespace)
    end

    def valid?(record)
      false
    end
  end
end
