module Konacha
  module SpecsHelper
    def spec_include_tag(*specs)
      bundler = SpecBundler.new(asset_paths)
      bundler.add_specs(specs)
      assets = bundler.assets

      asset_paths = assets.map { |a| asset_path(a) }
      javascript_include_tag *asset_paths, :debug => false
    end
  end
end
