require 'spec_helper'

describe AvroPinions::Configuration do

  class InvalidPublisher
  end
  class InvalidPublisher2
    def publish
    end
  end
  class ValidPublisher
    def publish(topic, message)
      # yep that's it
      42
    end
  end

  describe "publisher" do
    it "accepts a publishing target" do
      stuff = ValidPublisher.new
      AvroPinions.configure(publisher: stuff)

      expect(AvroPinions.configuration.publisher.publish('stuff', 'things')).to eq(42)
    end

    it "validates the publisher against some expected APIs" do
      expect {
        AvroPinions.configure(publisher: InvalidPublisher.new)
      }.to raise_exception(AvroPinions::Configuration::InvalidPublisher)
      expect {
        AvroPinions.configure(publisher: InvalidPublisher2.new)
      }.to raise_exception(AvroPinions::Configuration::InvalidPublisher)
      expect {
        AvroPinions.configure(publisher: ValidPublisher.new)
      }.to_not raise_error
    end
  end

  describe "schema registry" do
    # I could really TDD the hell out of this but I'm running short on time now.
    it "allows registry configuration" do
      config = AvroPinions.configuration
      config.schema_registry_options = {
          type: :file,
          schema_path: 'spec/support/schemas'
      }

      expect(config.schema_registry).to be_instance_of(AvroPinions::FileRegistry)
    end
  end
end
