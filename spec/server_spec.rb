require 'spec_helper'

describe Konacha::Server, :type => :feature do
  before do
    Konacha.mode = :server
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

  it "serves a subdirectory of specs" do
    visit "/subdirectory"
    page.should have_content("spec in subdirectory")
    page.should have_css(".test.pass")
  end

  it "serves a file with a period in the name" do
    visit "/jquery.plugin_spec"
    page.should have_content("jQuery.fn.plugin()")
    page.should have_css(".test.pass", :count => 1)
  end

  it "supports spec helpers" do
    visit "/spec_helper_spec"
    page.should have_content("two_plus_two")
    page.should have_css(".test.pass")
  end
end
