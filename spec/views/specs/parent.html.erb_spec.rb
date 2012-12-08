require 'spec_helper'

describe "konacha/specs/parent" do
  def spec_double(asset_name)
    double("spec called '#{asset_name}'", :asset_name => asset_name, :path => "#{asset_name}.js")
  end

  it "renders an iframe tag for a spec" do
    # https://github.com/rails/rails/issues/4364
    # https://github.com/rspec/rspec-rails/pull/539
    view.singleton_class.send(:include, Konacha::Engine.routes.url_helpers)

    spec = spec_double("a_spec")
    assign(:specs, [spec])

    render

    Capybara.string(rendered).find("iframe")[:src].should == "/iframe/a_spec"
  end
end
