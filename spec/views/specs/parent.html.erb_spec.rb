require 'spec_helper'

describe "konacha/specs/parent" do
  def spec_hash(asset_name)
    { :path => "#{asset_name}.js", :iframe_path => "/iframe/#{asset_name}" }
  end

  it "sets the Konacha.specs property to an object containing all specs" do
    # https://github.com/rails/rails/issues/4364
    # https://github.com/rspec/rspec-rails/pull/539
    view.singleton_class.send(:include, Konacha::Engine.routes.url_helpers)

    spec = spec_hash("a_spec")
    assign(:specs, [spec])
    assign(:run_mode, "server".inquiry)

    render

    expected = %(Konacha.specs = [{"path":"a_spec.js","iframe_path":"/iframe/a_spec"}])
    Capybara.string(rendered).find("script:last").text.should == expected
  end
end
