require 'spec_helper'

describe AvroPinions::Codec do
  before :each do
    AvroPinions.configuration.schema_registry_options = {
      type: :file,
      schema_path: 'spec/support/schemas'
    }
  end

  it "requests a schema from the registry when referred to" do
    codec = AvroPinions::Codec.new(schema_name: "BasicSample", namespace: "com.company.example")
    expect(codec.schema).to_not be_nil
  end

  it "validates a record" do
    codec = AvroPinions::Codec.new(schema_name: "BasicSample", namespace: "com.company.example")
    empty_record = {}
    expect(codec.valid?(empty_record)).to be_falsey
  end
end
