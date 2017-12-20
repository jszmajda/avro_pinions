require 'spec_helper'

describe AvroPinions::SchemaRegistry do
  let(:expected_schema) { "hi" }

  class SampleRegistry < AvroPinions::SchemaRegistry
    def load_schema(name, space)
    end
  end

  it "caches schema" do
    reg = SampleRegistry.new

    expect(reg).to receive(:load_schema).and_return(expected_schema).once
    result = reg.schema('name','space')
    result2 = reg.schema('name','space')
    result3 = reg.schema('name','space')
  end

  describe "#canonincal_name" do
    it "returns a dot-joined name" do
      reg = SampleRegistry.new

      cn = reg.canonical_name('SchemaName', 'some.namespace')
      expect(cn).to eq('some.namespace.SchemaName')
    end

    it "works without a namespace too" do
      reg = SampleRegistry.new

      cn = reg.canonical_name('SchemaName')
      expect(cn).to eq('SchemaName')
    end
  end

end
