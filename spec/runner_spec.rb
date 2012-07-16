require 'spec_helper'

describe Konacha::Runner do
  before do
    Konacha.mode = :runner
    Konacha.config.driver = :selenium_with_firebug
  end

  let(:runner) { Konacha::Runner.new(:output => buffer) }
  let(:buffer) { StringIO.new }

  describe "#run" do
    before { runner.run }

    it "prints results to the output" do
      buffer.rewind
      results = buffer.read
      # Failure output present?
      results.should include 'F'
      results.should include 'expected 4 to equal 5'
      # Pending output present?
      results.should include 'P'
      results.should include 'is pending'
      # Summary and dots
      results.should include "#{runner.examples.length} examples, 1 failures, 1 pending"
      results.should match /^[.FP]{#{runner.examples.length}}$/
    end
  end
end
