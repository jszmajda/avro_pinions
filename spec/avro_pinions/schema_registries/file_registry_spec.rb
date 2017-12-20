require 'spec_helper'

describe AvroPinions::FileRegistry do
  it "complains when not properly configured" do
    expect {
      fr = AvroPinions::FileRegistry.new({})
    }.to raise_error(AvroPinions::ConfigurationError)
  end

  it "loads schemas from a path" do
    fr = AvroPinions::FileRegistry.new(schema_path: 'spec/support/schemas')
    schema = fr.load_schema('BasicSample', 'com.company.example')

    expect(schema.name).to eq('BasicSample')
    expect(schema.namespace).to eq('com.company.example')
  end

  describe "#file_path" do
    # TODO
  end
end
