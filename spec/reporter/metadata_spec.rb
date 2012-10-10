require 'spec_helper'

describe Konacha::Reporter::Metadata do
  subject { described_class.new({}) }

  describe "#[]" do
    it "calls the method on self if available" do
      subject.should_receive(:full_description)
      subject[:full_description]
    end

    it "looks in the data hash" do
      subject.should_receive(:data) { {} }
      subject[:title]
    end
  end

  describe "#update" do
    it "merges the new data into the data hash" do
      subject.update(:title => "test")
      subject.data.should == {:title => "test"}
    end
  end

  describe "#exception" do
    it "returns unless the spec failed" do
      subject.exception.should be_nil
    end

    it "builds a SpecException object" do
      subject.update('status' => 'failed', 'error' => {'message' => 'expected this to work'})
      subject.exception.should be_a(Konacha::Reporter::SpecException)
      subject.exception.message.should == 'expected this to work'
      subject.exception.backtrace.should == []
    end
  end

  describe "#execution_result" do
    it "returns a hash with execution details" do
      subject.execution_result.keys.map(&:to_s).sort.should == [:exception, :finished_at, :run_time, :started_at, :status].map(&:to_s)
    end
  end

  describe "#pending" do
    it "returns true iff status is pending" do
      subject.update('status' => 'pending')
      subject.pending.should be_true
    end

    it "returns false" do
      subject.pending.should be_false
    end
  end

  describe "#description" do
    it "looks for data['title']" do
      subject.update('title' => 'super test')
      subject.description.should == 'super test'
    end
  end

  describe "#full_description" do
    it "looks for data['fullTitle']" do
      subject.update('fullTitle' => 'super test')
      subject.full_description.should == 'super test'
    end
  end
end
