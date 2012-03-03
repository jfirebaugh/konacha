module Konacha
  module SpecStubHelpers
    def new_spec(basename)
      double("spec called '#{basename}'", :basename => basename)
    end

    def new_asset(basename, dependencies)
      asset = double("asset called '#{basename}'")
      asset.stub(:to_s).and_return(basename)
      asset.stub(:to_a).and_return([dependencies, asset].flatten)
      asset_paths.stub(:asset_for).with(basename, "js").and_return(asset)
      asset
    end

    def new_spec_and_asset(basename, dependencies)
      spec = new_spec(basename)
      asset = new_asset(basename, dependencies)
      [spec, asset]
    end
  end
end
