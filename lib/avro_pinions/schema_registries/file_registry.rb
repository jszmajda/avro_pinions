require 'json'
require 'avro'
require 'avro-patches'

module AvroPinions
  class FileRegistry < SchemaRegistry
    def initialize(options = {})
      super()
      @path = options[:schema_path] or raise AvroPinions::ConfigurationError.new("please define the path to load schemas from")
    end

    def load_schema(schema_name, namespace)
      data = File.read(file_path(schema_name, namespace))
      json = JSON.parse(data)
      Avro::Schema.real_parse(json)
    end

    def file_path(schema_name, namespace)
      schema_file = "#{schema_name}.avsc"
      boring_filename = File.join(@path, schema_file)
      if File.exists?(boring_filename)
        boring_filename
      else
        fancy_filename = File.join(@path, *namespace.split(/\./), schema_file)
        if File.exists?(fancy_filename)
          fancy_filename
        else
          raise "File not found for namespace #{namespace} and schema #{schema_name}. Tried #{fancy_filename} and #{boring_filename}"
        end
      end
    end

  end
end
