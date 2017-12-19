require 'spec_helper'

describe AvroPinions::Configuration do
  it "accepts a publishing target" do
    stuff = Class.new do
      def publish(topic, message)
        42
      end
    end
    AvroPinions.configure(publisher: stuff.new)

    expect(AvroPinions.configuration.publisher.publish('stuff', 'things')).to eq(42)
  end
end
