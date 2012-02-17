require 'spec_helper'

describe "konacha/specs/show" do
  it "renders a script tag for @spec basename" do
    spec = stub(:basename => "spec")
    assign(:spec, spec)
    render
    rendered.should have_selector("script[src='/assets/spec.js']")
  end
end
