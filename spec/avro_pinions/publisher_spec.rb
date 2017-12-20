require 'spec_helper'

describe AvroPinions::Publisher do
  describe "construction" do
    it "properly assigns initialization variables" do
      pub = AvroPinions::Publisher.new(schema_name: 'SomeSchema', namespace: 'com.company.namespace')
      expect(pub.instance_variable_get('@schema_name')).to eq('SomeSchema')
      expect(pub.instance_variable_get('@namespace')).to eq('com.company.namespace')
    end

    it "allows optional namespace declaration" do
      pub = AvroPinions::Publisher.new(schema_name: 'SomeSchema')
      expect(pub.instance_variable_get('@namespace')).to eq(AvroPinions::Publisher::DEFAULT_NAMESPACE)
    end
  end

  describe "debugging help" do
    context "with debugging enabled" do
      before :each do
        ENV['DEBUG_AVRO'] = "true"
      end
      after :each do
        ENV['DEBUG_AVRO'] = nil
      end

      it "does not raise on an invalid record" do
        record = {} # something invalid
        pub = AvroPinions::Publisher.new(schema_name: 'SomeSchema', namespace: 'com.company.namespace')
        expect { pub.validate_and_publish!(record, "topic") }.to_not raise_exception
      end

      context "with explicit debug turned on" do
        it "raises on an invalid record" do
          record = {} # something invalid
          pub = AvroPinions::Publisher.new(schema_name: 'SomeSchema', namespace: 'com.company.namespace')
          pub.debug!

          expect { pub.validate_and_publish!(record, "topic") }.to raise_exception(AvroPinions::UnableToSerializeError)
        end

      end
    end

    context "not in production" do
      it "raises on an invalid record" do
        record = {} # something invalid
        pub = AvroPinions::Publisher.new(schema_name: 'SomeSchema', namespace: 'com.company.namespace')
        expect { pub.validate_and_publish!(record, "topic") }.to raise_exception(AvroPinions::UnableToSerializeError)
      end
    end

  end

  # Need to test these private methods to ensure protocol match
  # They're private to ensure the public API isn't confusing for this class
  describe "wire-safety" do
    it "encodes messages as base64" do
      pub = AvroPinions::Publisher.new(schema_name: 'SomeSchema', namespace: 'com.company.namespace')
      expect(pub.send(:wire_safe, "hello")).to eq(Base64.encode64("hello"))
    end
  end

  describe "publishing valid records" do
    it "publishes a message to Industrious" do
      Industrious.session.producer.reset_mocks!
      pub = AvroPinions::Publisher.new(schema_name: 'SomeSchema', namespace: 'com.company.namespace')
      pub.send(:publish_to_wire, "topic", "hello")
      messages = Industrious.session.producer.messages_for_topic("topic")
      expect(messages.length).to eq(1)
      expect(messages.last.value).to eq("hello")
    end
  end
end
