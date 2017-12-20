require 'spec_helper'

describe AvroPinions::Codec do

  it "requests a schema from the registry when referred to" do
    codec = AvroPinions::Codec.new(schema: "BasicSample", namespace: "com.company.example")
    expect(codec.schema).to_not be_nil
  end

  it "validates a record" do
    codec = AvroPinions::Codec.new(schema: "BasicSample", namespace: "com.company.example")
    empty_record = {}
    expect(codec.valid?(empty_record)).to be_false
  end
end
