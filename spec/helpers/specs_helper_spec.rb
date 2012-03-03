require "spec_helper"

describe Konacha::SpecsHelper do
  include Konacha::SpecStubHelpers
  let(:asset_paths) { helper.asset_paths }

  describe "#spec_include_tag" do
    it "accepts a single spec" do
      spec, asset = new_spec_and_asset("spec", [])
      output = helper.spec_include_tag(spec)
      output.should == "<script src=\"/assets/spec.js?body=1\" type=\"text/javascript\"></script>"
    end

    it "accepts a multiple specs" do
      spec1, asset1 = new_spec_and_asset("spec1", [])
      spec2, asset2 = new_spec_and_asset("spec2", [asset1])
      spec3, asset3 = new_spec_and_asset("spec3", [asset1])

      output = helper.spec_include_tag(spec2, spec3)
      output.should == "<script src=\"/assets/spec1.js?body=1\" type=\"text/javascript\"></script>\n<script src=\"/assets/spec2.js?body=1\" type=\"text/javascript\"></script>\n<script src=\"/assets/spec3.js?body=1\" type=\"text/javascript\"></script>"
    end
  end
end
