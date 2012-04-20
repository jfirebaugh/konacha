module Konacha
  module SpecsHelper
    def spec_include_tag(*specs)
      assets = specs.map do |spec|
        asset_paths.asset_for(spec.asset_name, "js").to_a
      end.flatten.uniq.map(&:logical_path)

      javascript_include_tag *(assets << {:body => true, :debug => false})
    end
  end
end
