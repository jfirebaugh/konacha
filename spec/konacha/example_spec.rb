require 'spec_helper'

describe Konacha::Example do
  def trace(opts = {})
    { "trace" => opts }
  end

  context "without additional failure info" do
    it "should not have an extra empty row" do
      ex = Konacha::Example.new({'message' => 'foo'})
      ex.failure_message.split("\n").count.should be 2
    end
  end

  it "should provide extra context for timeouts" do
    ex = Konacha::Example.new(trace("timeout of 2000ms exceeded"))
    ex.failure_message.should match "Execution of spec took too long"
    ex.failure_message.should match "or forgot to call done"
  end

  it "should provide a prettified location when fileName is present" do
    ex = Konacha::Example.new(trace("fileName" => "foo", "lineNumber" => 42))
    ex.failure_message.should match "in: foo:42"
  end
end
