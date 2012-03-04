require "spec_helper"

describe Konacha::SpecBundler do
  include Konacha::SpecStubHelpers
  let(:asset_paths) { double("asset paths") }
  let(:bundler) { Konacha::SpecBundler.new(asset_paths) }

  describe "#assets" do
    it "defaults to an empty set" do
      bundler.assets.should be_empty
    end
  end

  describe "#add_spec" do
    it "adds the corresponding asset for the spec" do
      spec, asset = new_spec_and_asset("spec", [])
      bundler.add_spec spec
      bundler.assets.should include(asset)
    end

    it "adds the spec's dependencies" do
      spec1, asset1 = new_spec_and_asset("spec1", [])
      spec2, asset2 = new_spec_and_asset("spec2", [])
      spec3, asset3 = new_spec_and_asset("spec3", [asset1, asset2])

      bundler.add_spec(spec3)
      bundler.assets.should include(asset1)
      bundler.assets.should include(asset2)
      bundler.assets.should include(asset3)
    end
  end

  describe "#add_specs" do
    it "adds each provided spec" do
      spec1, asset1 = new_spec_and_asset("spec1", [])
      spec2, asset2 = new_spec_and_asset("spec2", [])
      spec3, asset3 = new_spec_and_asset("spec3", [])

      bundler.add_specs([spec1, spec2, spec3])
      bundler.assets.should include(asset1)
      bundler.assets.should include(asset2)
      bundler.assets.should include(asset3)
    end
  end
end
