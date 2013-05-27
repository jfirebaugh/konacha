require 'spec_helper'

describe Konacha::Engine do
  describe ".formatters" do
    it "defaults to a Konacha::Formatter pointing to STDOUT" do
      Konacha::Formatter.should_receive(:new).with(STDOUT) { :formatter }
      Konacha::Engine.formatters.should == [:formatter]
    end

    context "with a FORMAT environment variable" do
      before do
        class TestFormatter
          def initialize(io)
          end
        end
        ENV['FORMAT'] = 'Konacha::Formatter,TestFormatter'
      end

      after do
        Object.send(:remove_const, :TestFormatter)
        ENV.delete('FORMAT')
      end

      it "creates the specified formatters" do
        Konacha::Formatter.should_receive(:new).with(STDOUT) { :formatter }
        TestFormatter.should_receive(:new).with(STDOUT) { :test_formatter }
        Konacha::Engine.formatters.should == [:formatter, :test_formatter]
      end
    end
  end
end
