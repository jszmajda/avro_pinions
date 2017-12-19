module AvroPinions
  class Message
    def topic
      # self.class::SYMBOL looks up a class constant in a child class
      if defined?(self.class::TOPIC)
        self.class::TOPIC
      else
        raise MessageBus::NotFullyImplementedError, 'No Topic defined'
      end
    end

    # Schema is inferred to be the .avsc file in the schemas folder with the
    # name as given
    def schema
      if defined?(self.class::SCHEMA)
        self.class::SCHEMA
      else
        raise MessageBus::NotFullyImplementedError, 'No Topic defined'
      end
    end

    def record
      raise MessageBus::NotFullyImplementedError, 'No Topic defined'
    end

    def publish
      pub = MessageBus::Publisher.new(schema_name: schema)
      pub.validate_and_publish!(record, topic)
    end

  end
end
