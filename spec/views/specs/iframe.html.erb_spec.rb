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

    view.stub(:javascript_include_tag)
    view.should_receive(:javascript_include_tag).with("a_spec")

    render
  end

  it "renders the stylesheets" do
    assign(:spec, spec_double("a_spec"))
    assign(:stylesheets, %w(foo bar))

    view.should_receive(:stylesheet_link_tag).with("foo", :debug => false)
    view.should_receive(:stylesheet_link_tag).with("bar", :debug => false)

    render
  end

  it "includes a path data attribute" do
    assign(:spec, spec_double("a_spec"))

    render

    rendered.should have_selector("[data-path='a_spec.js']")
  end
end
