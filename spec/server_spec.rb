require 'spec_helper'

describe Matcha::Server, :type => :request do
  def app
    Matcha.application
  end

  before do
    Matcha.mode = :server
  end

  it "serves a root page" do
    visit "/"
    page.should have_content("Array#sum (js)")
    page.should have_css(".test.pass")
  end

  it "serves an individual JavaScript spec" do
    visit "/array_sum_js_spec"
    page.should have_content("Array#sum (js)")
    page.should have_css(".test.pass", :count => 2)
  end

  it "serves an individual CoffeeScript spec" do
    visit "/array_sum_cs_spec"
    page.should have_content("Array#sum (cs)")
    page.should have_css(".test.pass", :count => 2)
  end

  it "serves a spec in a subdirectory" do
    visit "/subdirectory/subdirectory_spec"
    page.should have_content("spec in subdirectory")
    page.should have_css(".test.pass")
  end

  it "supports spec helpers" do
    visit "/spec_helper_spec"
    page.should have_content("two_plus_two")
    page.should have_css(".test.pass")
  end
end
