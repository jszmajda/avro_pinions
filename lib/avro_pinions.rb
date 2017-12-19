require "avro_pinions/version"
require 'avro_pinions/configuration'
require 'avro_pinions/message'

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
end
