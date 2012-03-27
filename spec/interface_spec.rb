require 'spec_helper'

describe Konacha, :type => :request do
  before do
    Konacha.mode = :server
  end

  after do
    Konacha.configure do |config|
      config.interface = :bdd
      config.spec_dir = "spec/javascripts"
    end
  end

  it "supports Mocha's TDD interface" do
    Konacha.configure do |config|
      config.interface = :tdd
      config.spec_dir = "spec/tdd"
    end

    visit "/tdd_spec"
    page.should have_content("tdd test")
    page.should have_css(".test.pass")
  end

  it "supports Mocha's QUnit interface" do
    Konacha.configure do |config|
      config.interface = :qunit
      config.spec_dir = "spec/qunit"
    end

    visit "/qunit_spec"
    page.should have_content("qunit test")
    page.should have_css(".test.pass")
  end
end
