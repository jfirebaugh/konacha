require 'spec_helper'

describe "layouts/matcha/specs" do
  it "sets up the specified interface" do
    assign(:interface, :tdd)
    render
    rendered.should include('mocha.setup("tdd")')
  end

  it "includes matcha JS for given mode" do
    assign(:mode, :runner)
    render
    rendered.should have_css("script[src='/assets/matcha/runner.js']")
  end
end
