require 'spec_helper'

describe "konacha/specs/iframe" do
  before do
    assign(:stylesheets, [])
  end

  def spec_double(asset_name)
    double("spec called '#{asset_name}'", :asset_name => asset_name, :path => "#{asset_name}.js")
  end

  it "renders a script tag for @spec" do
    assign(:spec, spec_double("a_spec"))

    render

    rendered.should have_selector("script[src='/assets/a_spec.js?body=1']")
  end

  it "renders the stylesheets" do
    assign(:spec, spec_double("a_spec"))
    assign(:stylesheets, %w(foo bar))

    render

    rendered.should have_selector("link[href='/assets/foo.css']")
    rendered.should have_selector("link[href='/assets/bar.css']")
  end

  it "includes a path data attribute" do
    assign(:spec, spec_double("a_spec"))

    render

    rendered.should have_selector("[data-path='a_spec.js']")
  end
end
