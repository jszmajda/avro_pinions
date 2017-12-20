module AvroPinions
  # Class to handle how we debug and publish messages
  class Publisher
    DEFAULT_NAMESPACE = 'com.optoro.inventory'.freeze

    def initialize(schema_name:, namespace: DEFAULT_NAMESPACE)
      @schema_name = schema_name
      @namespace = namespace
      @debug = !!ENV['DEBUG_AVRO']
    end

    def debug!
      @debug = true
    end

    def validate_and_publish!(record, topic)
      if AvroPinions.valid?(record, schema_name: @schema_name, namespace: @namespace)
        encoded = AvroPinions.encode(record, schema_name: @schema_name, namespace: @namespace)
        publish_to_wire(topic, wire_safe(encoded))
      elsif @debug
        # this call will raise a more useful exception clarifying why the
        # record is invalid
        AvroPinions.encode(record, schema_name: @schema_name, namespace: @namespace)
      end
    rescue Exception => e
      if @debug
        raise AvroPinions::UnableToSerializeError, "Invalid record: #{record.inspect}, Avro error: #{e.message}", caller
      end
    end

    # Private so the public API isn't confusing

    private

    def wire_safe(message)
      Base64.encode64(message)
    end

    def publish_to_wire(topic, message)
      Industrious.publish(topic, message)
    end

  end
end
