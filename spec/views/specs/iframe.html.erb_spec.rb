require 'spec_helper'

describe "konacha/specs/iframe" do
  before do
    assign(:stylesheets, [])
  end

  def asset_double(asset_name, dependencies = [])
    asset = double("asset called '#{asset_name}'")
    asset.stub(:to_a).and_return([dependencies, asset].flatten)
    asset.stub(:logical_path).and_return(asset_name)
    view.asset_paths.stub(:asset_for).with(asset_name, "js").and_return(asset)
    asset
  end

  def spec_double(asset_name, dependencies = [])
    asset_double(asset_name, dependencies)
    double("spec called '#{asset_name}'", :asset_name => asset_name)
  end

  let(:dependency) { asset_double("dependency") }

  it "renders a script tag for @spec" do
    assign(:spec, spec_double("a_spec"))

    render

    rendered.should have_selector("script[src='/assets/a_spec.js?body=1']")
  end

  it "renders a script tag for a spec's dependencies" do
    assign(:spec, spec_double("spec", [dependency]))

    render

    rendered.should have_selector("script[src='/assets/dependency.js?body=1']")
    rendered.should have_selector("script[src='/assets/spec.js?body=1']")
  end

  it "renders only one script tag for dependencies of dependencies" do
    dependency_a = asset_double("dependency_a")
    dependency_b = asset_double("dependency_b", [dependency_a])

    assign(:spec, spec_double("a_spec", [dependency_a, dependency_b]))

    render

    rendered.should have_selector("script[src='/assets/dependency_a.js?body=1']", :count => 1)
    rendered.should have_selector("script[src='/assets/dependency_b.js?body=1']", :count => 1)
  end

  it "render the stylesheets" do
    assign(:spec, spec_double("a_spec"))
    assign(:stylesheets, %w(foo bar))
    assign(:specs, [])

    render

    rendered.should have_selector("link[href='/assets/foo.css']")
    rendered.should have_selector("link[href='/assets/bar.css']")
  end
end
