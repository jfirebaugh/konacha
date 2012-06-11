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

    it "returns specs passed via the ENV['spec'] parameter" do
      ENV["SPEC"] = "foo_spec,bar_spec,baz_spec"
      all = described_class.all
      all.length.should == 3
      paths = all.map {|p| p.path}
      paths =~ %w{foo_spec bar_spec baz_spec}
      ENV["SPEC"] = nil
    end
  end

  describe ".find" do
    it "returns all Specs if given an empty path" do
      all = ["a_spec.js", "b_spec.js"]
      Konacha.should_receive(:spec_paths) { all }
      described_class.find("").map(&:path).should == all
    end

    it "returns an array containing the Spec with the given asset_name" do
      all = ["a_spec.js", "b_spec.js"]
      Konacha.should_receive(:spec_paths) { all }
      described_class.find("b_spec").map(&:path).should == [all[1]]
    end

    it "returns Specs that are children of the given path" do
      all = ["a/a_spec_1.js", "a/a_spec_2.js", "b/b_spec.js"]
      Konacha.should_receive(:spec_paths) { all }
      described_class.find("a").map(&:path).should == all[0..1]
    end

    it "raises NotFound if no Specs match" do
      Konacha.should_receive(:spec_paths) { [] }
      expect { described_class.find("b_spec") }.to raise_error(Konacha::Spec::NotFound)
    end
  end
end
