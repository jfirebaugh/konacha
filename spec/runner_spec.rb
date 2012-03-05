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
      # "should include" gives us nice multi-line error messages if there is
      # more than one failure
      results.should include 'examples, 1 failure'
      # Failure output present?
      results.should include 'F'
      results.should include 'expected 4 to equal 5'
      # Enough examples run?
      results.should match /[1-9][0-9]+ examples, 1 failure/
    end
  end

  describe "#run_spec" do
    let(:spec) { Konacha::Spec.find("failing_spec").first }
    before { runner.spec_runner(spec).run }

    it "prints results to the output" do
      buffer.rewind
      results = buffer.read
      results.should include('F')
      results.should include("expected 4 to equal 5")
      results.should include("1 examples, 1 failures")
    end
  end
end
