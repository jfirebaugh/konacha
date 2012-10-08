require 'spec_helper'

describe Konacha::Reporter::Example do
  subject { described_class.new({}, nil) }

  describe "#initialize" do
    it "loads up a metadata instance and the parent" do
      data = double('data')
      parent = double('parent')
      example = described_class.new(data, parent)

      example.parent.should == parent
      example.metadata.should be_a(Konacha::Reporter::Metadata)
      example.metadata.data.should == data
    end
  end

  describe "delegated methods" do
    let(:metadata) { double('metadata') }
    before { Konacha::Reporter::Metadata.stub(:new) { metadata } }

    [:full_description, :description, :location, :file_path, :line_number, :pending, :pending_message, :exception, :execution_result].each do |method|
      it "delegates #{method} to metadata" do
        metadata.should_receive(method)
        subject.send(method)
      end
    end
  end

  describe "aliased_methods" do
    it "aliases pending? to pending" do
      subject.pending?.should == subject.pending
    end

    it "aliases options to metadata" do
      subject.options.should == subject.metadata
    end

    it "aliases example_group to parent" do
      subject.example_group.should == subject.parent
    end
  end

  describe "#passed?" do
    it "returns true iff execution_result[:status] is passed" do
      subject.should_receive(:execution_result) { {:status => "passed"} }
      subject.passed?.should be_true
    end

    it "returns false" do
      subject.should_receive(:execution_result) { {} }
      subject.passed?.should be_false
    end
  end

  describe "#failed?" do
    it "returns true iff execution_result[:status] is failed" do
      subject.should_receive(:execution_result) { {:status => "failed"} }
      subject.failed?.should be_true
    end

    it "returns false" do
      subject.should_receive(:execution_result) { {} }
      subject.failed?.should be_false
    end
  end

  describe "#update_metadata" do
    it "calls metadata.update" do
      data = double('data')
      metadata = double('metadata')
      metadata.should_receive(:update).with(data)
      Konacha::Reporter::Metadata.stub(:new) { metadata }
      subject.update_metadata(data)
    end
  end
end
