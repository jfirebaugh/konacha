module Konacha
  module SpecStubHelpers
    def new_spec(asset_name)
      double("spec called '#{asset_name}'", :asset_name => asset_name)
    end

    def new_asset(name, dependencies)
      asset = double("asset called '#{name}'")
      asset.stub(:to_s).and_return(name)
      asset.stub(:to_a).and_return([dependencies, asset].flatten)
      asset_paths.stub(:asset_for).with(name, "js").and_return(asset)
      asset
    end

    def new_spec_and_asset(name, dependencies)
      spec = new_spec(name)
      asset = new_asset(name, dependencies)
      [spec, asset]
    end
  end
end
