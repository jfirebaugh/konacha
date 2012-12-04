require 'spec_helper'

describe "konacha/specs/parent" do
  def spec_double(asset_name)
    double("spec called '#{asset_name}'", :asset_name => asset_name, :path => "#{asset_name}.js")
  end

  it "renders an iframe tag for a spec" do
    spec = spec_double("a_spec")
    assign(:specs, [spec])

    render

    Capybara.string(rendered).find("iframe")[:src].should == "/iframe/a_spec"
  end
end
