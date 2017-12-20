require "avro_pinions/version"
require 'avro_pinions/configuration'
require 'avro_pinions/publisher'
require 'avro_pinions/message'
require 'avro_pinions/schema_registry'
require 'avro_pinions/codec'

module AvroPinions
  # Your code goes here...
  module_function

  def configuration
    AvroPinions::Configuration.instance
  end

  def configure(messages)
    if messages.respond_to?(:each_pair)
      messages.each_pair do |key, value|
        if value && configuration.respond_to?("#{key}=")
          configuration.send("#{key}=", *value)
        elsif configuration.respond_to?(key)
          configuration.send(key, *value)
        end
      end
    else
      configuration.send(messages)
    end
  end

  def publisher
    configuration.publisher
  end
  def schema_registry
    configuration.schema_registry
  end

  class NotFullyImplementedError < StandardError
  end
  class UnableToSerializeError < StandardError
  end
  class ConfigurationError < StandardError
  end
end
