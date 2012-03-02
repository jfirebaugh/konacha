require "spec_helper"

describe Konacha::SpecBundler do
  let(:asset_paths) { double("asset paths") }
  let(:bundler) { Konacha::SpecBundler.new(asset_paths) }

  def new_spec_asset(*dependencies)
    basename = double("basename")
    spec = double("spec", :basename => basename)

    asset = double("asset")
    asset.stub(:to_a).and_return([asset, dependencies].flatten)

    asset_paths.stub(:asset_for).with(basename).and_return(asset)
    [spec, asset]
  end

  describe "#assets" do
    it "defaults to an empty set" do
      bundler.assets.should be_empty
    end
  end

  describe "#add_spec" do
    it "adds the corresponding asset for the spec" do
      spec, asset = new_spec_asset
      bundler.add_spec spec
      bundler.assets.should include(asset)
    end

    it "adds the spec's dependencies" do
      spec1, asset1 = new_spec_asset
      spec2, asset2 = new_spec_asset
      spec3, asset3 = new_spec_asset(asset1, asset2)

      bundler.add_spec(spec3)
      bundler.assets.should include(asset1)
      bundler.assets.should include(asset2)
      bundler.assets.should include(asset3)
    end
  end

  describe "#add_specs" do
    it "adds each provided spec" do
      spec1, asset1 = new_spec_asset
      spec2, asset2 = new_spec_asset
      spec3, asset3 = new_spec_asset

      bundler.add_specs(spec1, spec2, spec3)
      bundler.assets.should include(asset1)
      bundler.assets.should include(asset2)
      bundler.assets.should include(asset3)
    end
  end
end
