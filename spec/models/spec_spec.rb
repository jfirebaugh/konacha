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

    it "returns all Specs if given an empty path" do
      all = ["a_spec.js", "b_spec.js"]
      Konacha.should_receive(:spec_paths) { all }
      described_class.all("").map(&:path).should == all
    end

    it "returns an array containing the Spec with the given asset_name" do
      all = ["a_spec.js", "b_spec.js"]
      Konacha.should_receive(:spec_paths) { all }
      described_class.all("b_spec").map(&:path).should == [all[1]]
    end

    it "returns Specs that are children of the given path" do
      all = ["a/a_spec_1.js", "a/a_spec_2.js", "b/b_spec.js"]
      Konacha.should_receive(:spec_paths) { all }
      described_class.all("a").map(&:path).should == all[0..1]
    end

    it "ignores grep matching config.iframe_economy is set to false" do
      default_config = Konacha.config.iframe_economy
      Konacha.config.iframe_economy = false
      all = ["a_spec.js", "b_spec.js"]
      Konacha.should_receive(:spec_paths) { all }
      described_class.all(nil, "a").map(&:path).should == all
      Konacha.config.iframe_economy = default_config
    end

    it "returns Specs that match a given grep" do
      default_config = Konacha.config.iframe_economy
      Konacha.config.iframe_economy = true
      all = ["a_description_spec.js", "b_spec.js"]
      Konacha.should_receive(:spec_paths) { all }
      described_class.all(nil, "A description a specific test").map(&:path).should == [all[0]]
      Konacha.config.iframe_economy = default_config
    end

    it "returns all Specs if given an empty grep" do
      default_config = Konacha.config.iframe_economy
      Konacha.config.iframe_economy = true
      all = ["a_spec.js", "b_spec.js"]
      Konacha.should_receive(:spec_paths) { all }
      described_class.all(nil, nil).map(&:path).should == all
      Konacha.config.iframe_economy = default_config
    end

    it "raises NotFound if no Specs match" do
      Konacha.should_receive(:spec_paths) { [] }
      expect { described_class.all("b_spec") }.to raise_error(Konacha::Spec::NotFound)
    end
  end

  describe ".find_by_name" do
    it "returns the spec with the given asset name" do
      all = ["a_spec.js", "b_spec.js"]
      Konacha.should_receive(:spec_paths) { all }
      described_class.find_by_name("a_spec").path.should == "a_spec.js"
    end

    it "raises NotFound if no Specs match" do
      Konacha.should_receive(:spec_paths) { [] }
      expect { described_class.find_by_name("b_spec") }.to raise_error(Konacha::Spec::NotFound)
    end
  end
end
