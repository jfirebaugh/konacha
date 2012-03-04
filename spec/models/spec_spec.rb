require 'spec_helper'

describe Konacha::Spec do
  describe "#asset_name" do
    it "is the asset_name of the path" do
      described_class.new("array_spec.js").asset_name.should == "array_spec"
      described_class.new("array_spec.coffee").asset_name.should == "array_spec"
    end

    it "ignores multiple extensions" do
      described_class.new("array_spec.js.coffee").asset_name.should == "array_spec"
    end

    it "includes relative path" do
      described_class.new("subdirectory/array_spec.js").asset_name.should == "subdirectory/array_spec"
    end
  end

  describe "#url" do
    it "returns a URL path" do
      described_class.new("array_spec.js").url.should == "/array_spec"
    end
  end

  describe ".all" do
    it "returns an array of specs" do
      Konacha.should_receive(:spec_paths) { ["a_spec.js", "b_spec.js"] }
      all = described_class.all
      all.length.should == 2
    end
  end

  describe ".find" do
    it "returns the Spec with the given asset_name" do
      all = [described_class.new("a_spec.js"),
             described_class.new("b_spec.js")]
      described_class.should_receive(:all) { all }
      described_class.find("b_spec").should == all[1]
    end

    it "returns nil if no such spec exists" do
      described_class.should_receive(:all) { [] }
      described_class.find("b_spec").should be_nil
    end
  end
end
