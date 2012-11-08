module Konacha
  module SpecsHelper
    include RequirejsHelper

    def spec_include_tag(*specs)
      assets = specs.map do |spec|
        asset_paths.asset_for(spec.asset_name, "js").to_a
      end.flatten.map(&:logical_path).uniq

      javascript_include_tag *(assets << {:body => true, :debug => false})
    end
  end
end
