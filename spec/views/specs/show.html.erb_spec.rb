require 'spec_helper'

describe "konacha/specs/show" do
  include Konacha::SpecStubHelpers
  let(:asset_paths) { view.asset_paths }

  it "renders a script tag for @spec basename" do
    spec, asset = new_spec_and_asset("spec", [])
    assign(:spec, spec)
    render
    rendered.should have_selector("script[src='/assets/spec.js']")
  end
end
