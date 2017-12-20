# I have a PR open on the avro core to include these capabilities, but for now
# whatever I guess..
require 'avro'
require 'avro-patches'
module Avro
  class Schema

    CRC_EMPTY = 0xc15d213aa4d7a795

    # The java library caches this value after initialized, so this pattern
    # mimics that.
    @@fp_table = nil
    def initFPTable
      @@fp_table = Array.new(256)
      256.times do |i|
        fp = i
        8.times do |j|
          fp = (fp >> 1) ^ ( CRC_EMPTY & -( fp & 1 ) )
        end
        @@fp_table[i] = fp
      end
    end

    def crc_64_avro_fingerprint
      parsing_form = Avro::SchemaNormalization.to_parsing_form(self)
      data_bytes = parsing_form.unpack("C*")

      initFPTable unless @@fp_table

      fp = CRC_EMPTY
      data_bytes.each do |b|
        fp = (fp >> 8) ^ @@fp_table[ (fp ^ b) & 0xff ]
      end
      fp
    end

  end

  module IO
    class SingleObjectMessage
      def initialize(schema)
        @schema = schema
      end

      SINGLE_OBJECT_MAGIC_NUMBER = [0xC3, 0x01]
      def header
        [SINGLE_OBJECT_MAGIC_NUMBER, schema_fingerprint].flatten
      end
      def schema_fingerprint
        working = @schema.crc_64_avro_fingerprint
        bytes = Array.new(8)
        8.times do |i|
          bytes[7 - i] = (working & 0xff)
          working = working >> 8
        end
        bytes
      end
    end
  end
end

