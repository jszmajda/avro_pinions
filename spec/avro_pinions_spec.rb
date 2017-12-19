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
      AvroPinions.configure(publisher: Object.new)
      expect(AvroPinions.configuration.publisher).to receive('hi').with('there')

      AvroPinions.publisher.hi('there')
    end
  end

  it "validates a message against a schema" do
    #AvroPinions::Message.valid?
  end
  it "publishes a message" do 
    #pub = MessageBus::Publisher.new(schema_name: schema)
    #pub.validate_and_publish!(record, topic)
  end
end
