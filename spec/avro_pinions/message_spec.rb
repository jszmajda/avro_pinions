require 'spec_helper'

describe AvroPinions::Message do

  before :all do
    AvroPinions.configure(publisher: TestPublisher.new)
  end

  describe "unimplemented defaults" do
    subject { AvroPinions::Message.new }

    it "raises when no topic is defined" do
      expect { subject.topic }.to raise_exception(AvroPinions::NotFullyImplementedError)
    end

    it "raises when no record is defined" do
      expect { subject.record }.to raise_exception(AvroPinions::NotFullyImplementedError)
    end

    it "raises when no schema is defined" do
      expect { subject.schema }.to raise_exception(AvroPinions::NotFullyImplementedError)
    end

    it "has no default publish strategy" do
      expect { subject.publish }.to raise_exception(AvroPinions::NotFullyImplementedError)
    end
  end

  describe "example implementation" do
    class SampleAvroPinionsMessage < AvroPinions::Message
      TOPIC = 'test topic'.freeze
      SCHEMA = 'Test'.freeze
      def initialize(data)
        @data = data
      end

      def record
        { value: @data }
      end
    end
    subject { SampleAvroPinionsMessage }

    let(:messages) { AvroPinions.publisher.messages['test topic'] }

    before :each do
      AvroPinions.publisher.reset!
      subject.new('sample data').publish
    end

    it "publishes a message to the proper topic" do
      expect(messages.length).to eq(1)
    end
  end

  describe "example implementation with defaults" do
    class SampleAvroPinionsMessageWithDefaults < AvroPinions::Message
      TOPIC = 'test topic'.freeze
      SCHEMA = 'Test'.freeze
      def initialize(data)
        @data = data
      end

      def record
        { value: @data }
      end
    end
    subject { SampleAvroPinionsMessageWithDefaults }

    it "defaults the topic to TOPIC" do
      expect(subject.new('hi').topic).to eq('test topic')
    end

    it "defaults the schema to SCHEMA" do
      expect(subject.new('hi').schema).to eq('Test')
    end
  end

  describe "#avro_schema" do
    before :each do
      configure_avro_pinions_for_local_test_files
    end

    it "returns an Avro schema" do
      message = BasicMessage.new('hi')
      expect(message.avro_schema).to be_instance_of(Avro::Schema::RecordSchema)
    end
  end

  describe "#encode" do
    it "calls the codec to encode data" do
      message = BasicMessage.new('hi')
      expect_any_instance_of(AvroPinions::Codec).to receive(:encode).with(message.record)
      message.encode
    end
  end

  describe "validation" do
    it "validates a record" do
      message = BasicMessage.new(nil)
      expect(message.valid?).to be false

      message2 = BasicMessage.new("hi")
      expect(message2.valid?).to be true
    end

    it "raises when an invalid record is encoded" do
      AvroPinions.configure(wire_format: :single_object)

      message = BasicMessage.new(nil)
      expect {
        message.encode
      }.to raise_exception(Avro::IO::AvroTypeError)
    end
  end
end
