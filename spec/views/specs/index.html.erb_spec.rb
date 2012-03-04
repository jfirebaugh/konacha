require 'spec_helper'

describe "konacha/specs/index" do
  it "renders a script tag for each asset_name in @specs" do
    a_spec = stub(:asset_name => "a_spec")
    b_spec = stub(:asset_name => "b_spec")
    assign(:specs, [a_spec, b_spec])
    render
    rendered.should have_selector("script[src='/assets/a_spec.js']")
    rendered.should have_selector("script[src='/assets/b_spec.js']")
  end
end
