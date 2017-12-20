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
      config = AvroPinions.configuration
 
      expect {
        config.publisher = InvalidPublisher.new
      }.to raise_exception(AvroPinions::Configuration::InvalidConfiguration)
      expect {
        config.publisher = InvalidPublisher2.new
      }.to raise_exception(AvroPinions::Configuration::InvalidConfiguration)
      expect {
        config.publisher = ValidPublisher.new
      }.to_not raise_error
    end
  end

  describe "schema registry" do
    # I could really TDD the hell out of this but I'm running short on time now.
    it "allows registry configuration" do
      config = AvroPinions.configuration
      config.schema_registry = {
          type: :file,
          schema_path: 'spec/support/schemas'
      }

      expect(config.schema_registry).to be_instance_of(AvroPinions::FileRegistry)
    end
  end

  describe "wire format" do
    it "raises on a nil wire format" do
      config = AvroPinions.configuration
      expect {
        config.wire_format = nil
      }.to raise_exception(AvroPinions::Configuration::InvalidConfiguration)
    end

    it "raises on an empty wire format" do
      config = AvroPinions.configuration
      expect {
        config.wire_format = ""
      }.to raise_exception(AvroPinions::Configuration::InvalidConfiguration)
    end

    it "raises on an invalid wire format" do
      config = AvroPinions.configuration
      expect {
        config.wire_format = :lololol
      }.to raise_exception(AvroPinions::Configuration::InvalidConfiguration)
    end

    it "accepts a valid wire format" do
      config = AvroPinions.configuration
      fmt = AvroPinions::Codec::SUPPORTED_WIRE_FORMATS.sample

      config.wire_format = fmt

      expect(config.wire_format).to eq(fmt)
    end
  end
end
