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

      def topic
        TOPIC
      end

      def schema
        SCHEMA
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

    xit "encodes the proper data" do
      expect(messages.length).to eq(1)

      b64 = messages.last
      decoded = AvroPinions.avro.decode(Base64.decode64(b64))
      expect(decoded['value']).to eq('sample data')
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

end
