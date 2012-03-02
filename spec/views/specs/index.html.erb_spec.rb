require 'spec_helper'

describe "konacha/specs/index" do
  include Konacha::SpecStubHelpers
  let(:asset_paths) { view.asset_paths }

  it "renders a script tag for each spec in @specs" do
    a_spec, a_asset = new_spec_and_asset("a_spec", [])
    b_spec, b_asset = new_spec_and_asset("b_spec", [])
    assign(:specs, [a_spec, b_spec])
    render
    rendered.should have_selector("script[src='/assets/a_spec.js?body=1']")
    rendered.should have_selector("script[src='/assets/b_spec.js?body=1']")
  end
end
