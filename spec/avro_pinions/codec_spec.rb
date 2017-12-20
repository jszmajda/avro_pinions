require 'spec_helper'

describe AvroPinions::Codec do
  let(:sample_schema) {
    Avro::Schema.parse <<-EOT
      { "type": "int" }
    EOT
  }

  before :each do
    AvroPinions.configure( wire_format: :single_object )
  end

  describe "encoding" do
    it "uses the wire format given in the config" do
      codec = AvroPinions::Codec.new(sample_schema)
      expect(codec.wire_format).to eq(:single_object)
    end

    it "encodes with the proper format" do
      codec = AvroPinions::Codec.new(sample_schema)
      expect(codec).to receive(:encode_as_single_object).with(42)
      encoded = codec.encode(42)
    end

    it "encodes a message" do
      codec = AvroPinions::Codec.new(sample_schema)
      encoded = codec.encode(42)
      expect(encoded).to_not be_nil
    end
  end

  describe "pedantry for Avro" do
    it "passes through ints" do
      result = AvroPinions::Codec.pedantic_data(24)
      expect(result).to eq(24)
    end

    it "converts symbol keys to strings" do
      result = AvroPinions::Codec.pedantic_data({hi: :there})
      expect(result.keys).to eq(["hi"])
    end

    it "converts symbol values to strings" do
      result = AvroPinions::Codec.pedantic_data({hi: :there})
      expect(result["hi"]).to eq("there")
    end
  end
end
