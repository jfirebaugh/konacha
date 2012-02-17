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
      results.should include(".......F.....")
      results.should include("expected 4 to equal 5")
      results.should include("13 examples, 1 failure")
    end
  end

  describe "#run_spec" do
    let(:spec) { Konacha::Spec.find("failing_spec") }
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
