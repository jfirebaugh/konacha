module Konacha
  module SpecsHelper
    def spec_include_tag(*specs)
      bundler = SpecBundler.new(asset_paths)
      bundler.add_specs(specs)
      assets = bundler.assets.map { |a| asset_path(a) }

      @javascript_include ||= ActionView::Helpers::AssetTagHelper::JavascriptIncludeTag.new(config, asset_paths)
      @javascript_include.include_tag(*assets)
    end
  end
end
