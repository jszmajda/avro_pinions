module AvroPinions
  class SchemaRegistry
    def initialize
      @cache = {}
    end

    def schema(schema_name, namespace = "")
      with_cache(schema_name, namespace) do
        load_schema(schema_name, namespace)
      end
    end

    def canonical_name(schema_name, namespace = "")
      if namespace.length > 0
        "#{namespace}.#{schema_name}"
      else
        schema_name
      end
    end

    def load_schema(schema_name, namespace)
      raise AvroPinions::NotFullyImplementedError.new("Please define how to load schemas")
    end

    def with_cache(schema_name, namespace, &block)
      key = canonical_name(schema_name, namespace)

      unless @cache.has_key?(key)
        @cache[key] = block.call
      end

      @cache[key]
    end
  end
end

# has to go below because these classes inherit. Yeah..
require 'avro_pinions/schema_registries/file_registry'
