module Konacha
  class SpecBundler
    attr_reader :assets

    def initialize(asset_paths)
      @asset_paths = asset_paths
      @assets = Set.new
    end

    def add_spec(spec)
      asset = @asset_paths.asset_for(spec.asset_name, "js")
      @assets.merge(asset.to_a)
    end

    def add_specs(specs)
      specs.each { |s| add_spec(s) }
    end
  end
end
