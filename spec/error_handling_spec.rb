require 'spec_helper'

describe Konacha, :type => :feature do
  before do
    Konacha.mode = :server
  end

  around do |example|
    begin
      spec_dir = Konacha.config.spec_dir
      Konacha.config.spec_dir = "spec/isolated/errors"
      example.run
    ensure
      Konacha.config.spec_dir = spec_dir
    end
  end

  it "inserts a failing test when an iframe fails to load" do
    silencing_stderr do
      visit "/failing_iframe_spec"
      page.should have_content("failing_iframe_spec.js.coffee")
      page.should have_css(".test.fail")
    end
  end

  def silencing_stderr
    stderr = $stderr
    $stderr = StringIO.new
    yield
  ensure
    $stderr = stderr
  end
end
