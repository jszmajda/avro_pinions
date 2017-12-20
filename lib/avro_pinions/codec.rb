module AvroPinions
  class Codec

    SUPPORTED_WIRE_FORMATS = [:single_object]

    def self.pedantic_data(data)
      if data.respond_to?(:each_pair)
        data.each_pair.inject({}) do |result, (k,v)|
          strrep = v.to_s
          result[k.to_s] = if strrep.to_sym == v
                             strrep
                           else
                             v
                           end
          result
        end
      else
        data
      end
    end

    attr_accessor :schema
    def initialize(schema)
      @schema = schema
    end

    def encode(data)
      self.send("encode_as_#{wire_format}", data)
    end

    def wire_format
      AvroPinions.configuration.wire_format
    end

    def encode_as_single_object(data)
      soc = SingleObjectCodec.new(schema)
      soc.encode(self.class.pedantic_data(data))
    end

    class SingleObjectCodec
      attr_reader :schema
      def initialize(schema)
        @schema = schema
      end

      def encode(data)
        stream = StringIO.new
        writer = Avro::IO::DatumWriter.new(@schema)
        encoder = Avro::IO::BinaryEncoder.new(stream)

        smd = Avro::IO::SingleObjectMessage.new(@schema)
        smd.header.each do |segment|
          stream.write( segment.chr )
        end
        writer.write(data, encoder)

        stream.string
      end
    end
  end
end
