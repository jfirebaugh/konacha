require 'spec_helper'

describe "konacha/specs/show" do
  it "renders a script tag for @spec" do
    assign(:spec, spec_double("spec"))
    render
    rendered.should have_selector("script[src='/assets/spec.js?body=1']")
  end
end
