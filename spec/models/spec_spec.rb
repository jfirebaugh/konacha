require 'spec_helper'

describe Matcha::Spec do
  describe "#basename" do
    it "is the basename of the path" do
      described_class.new("array_spec.js").basename.should == "array_spec"
    end

    it "ignores multiple extensions" do
      described_class.new("array_spec.js.coffee").basename.should == "array_spec"
    end

    it "includes relative path" do
      described_class.new("subdirectory/array_spec.js").basename.should == "subdirectory/array_spec"
    end
  end

  describe "#url" do
    it "returns a URL path" do
      described_class.new("array_spec.js").url.should == "/array_spec"
    end
  end

  describe ".all" do
    it "returns an array of specs" do
      Matcha.should_receive(:spec_paths) { ["a_spec.js", "b_spec.js"] }
      all = described_class.all
      all.length.should == 2
    end
  end

  describe ".find" do
    it "returns the Spec with the given basename" do
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
