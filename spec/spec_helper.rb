ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rspec/rails"
require "rspec/autorun"

# Preload to avoid occasional tilt warnings about thread safety
require "coffee_script"
require "ejs"

require "capybara/rails"
require "capybara/firebug"

Capybara.configure do |config|
  config.default_selector = :css
  config.default_driver   = :selenium_with_firebug
  config.app              = Konacha.application
end

module SpecDoubleHelpers
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
end

RSpec.configure do |config|
  config.include SpecDoubleHelpers, :type => :view
end
