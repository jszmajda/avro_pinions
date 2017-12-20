require "spec_helper"

RSpec.describe AvroPinions do
  it "has a version number" do
    expect(AvroPinions::VERSION).not_to be nil
  end

  describe "configuration" do
    it "accesses configuration" do
      config = AvroPinions.configuration
      config2 = AvroPinions.configuration
      expect(config).to be(config2)
    end

    it "passes through configure commands to confguration" do
      expect(AvroPinions.configuration).to receive(:hi).with(:stuff, :things)
      AvroPinions.configure(:hi => [:stuff, :things])
    end

    it "passes through publisher to the configuration publisher" do
      AvroPinions.configure(publisher: TestPublisher.new)
      expect(AvroPinions.configuration.publisher).to receive('hi').with('there')

      AvroPinions.publisher.hi('there')
    end
  end

  it "validates a message against a schema" do
    #AvroPinions::Message.valid?
  end

  it "publishes a message properly" do
    AvroPinions.configure({
      wire_format: :single_object,
      schema_registry: {
        type: :file,
        schema_path: 'spec/support/schemas'
      },
      publisher: TestPublisher.new
    })

    message = BasicMessage.new("hi there")
    AvroPinions.publish(message)

    last_message = AvroPinions.publisher.messages[message.topic].last

    expect(last_message).to_not be_nil

    # unpack to make sure we're treating the binary data without bias
    bin_data = last_message.unpack("C*")
    body = bin_data[10..-1] # 10 because of the SOM header

    reader = Avro::IO::DatumReader.new(message.avro_schema)
    io = StringIO.new(body.pack("C*"))
    decoder = Avro::IO::BinaryDecoder.new(io)
    object = reader.read(decoder)

    expect(object).to eq(AvroPinions::Codec.pedantic_data(message.record))
  end
end
