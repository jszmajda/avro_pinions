module AvroPinions
  class Message
    def topic
      # self.class::SYMBOL looks up a class constant in a child class
      if defined?(self.class::TOPIC)
        self.class::TOPIC
      else
        raise AvroPinions::NotFullyImplementedError, 'No Topic defined'
      end
    end

    # Schema is inferred to be the .avsc file in the schemas folder with the
    # name as given
    def schema
      if defined?(self.class::SCHEMA)
        self.class::SCHEMA
      else
        raise AvroPinions::NotFullyImplementedError, 'No Schema defined'
      end
    end

    def namespace
      if defined?(self.class::NAMESPACE)
        self.class::NAMESPACE
      else
        raise AvroPinions::NotFullyImplementedError, 'No Namespace defined'
      end
    end

    def record
      raise AvroPinions::NotFullyImplementedError, 'record method not implemented'
    end

    def publish
      AvroPinions.publisher.publish(topic, record)
    end

    def encode
      codec.encode(record)
    end

    def valid?
      Avro::Schema.validate(avro_schema, AvroPinions::Codec.pedantic_data(record))
    end

    def codec
      @codec ||= AvroPinions::Codec.new(avro_schema)
    end

    def avro_schema
      @avro_schema ||= AvroPinions.schema_registry.schema(schema, namespace)
    end

    class InvalidRecord < StandardError
    end
  end
end
