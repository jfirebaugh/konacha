require 'spec_helper'

describe "layouts/konacha/specs" do
  it "sets up the specified interface" do
    assign(:interface, :tdd)
    render
    rendered.should include('mocha.setup("tdd")')
  end

  it "includes konacha JS for given mode" do
    assign(:mode, :runner)
    render
    rendered.should have_css("script[src='/assets/konacha/runner.js']")
  end
end
