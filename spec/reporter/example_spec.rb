require 'spec_helper'

describe Konacha::Reporter::Example do
  subject { described_class.new({}, nil) }

  describe "#initialize" do
    it "loads up a metadata instance and the parent" do
      data = double('data')
      parent_metadata = Konacha::Reporter::Metadata.new({})
      parent = double('parent', metadata: parent_metadata)

      # Check if parent metadata is added to metadata
      described_class.any_instance.stub(:update_metadata) { nil }
      described_class.any_instance.should_receive(:update_metadata).with(example_group: parent_metadata)

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
      subject.passed?.should == true
    end

    it "returns false" do
      subject.should_receive(:execution_result) { {} }
      subject.passed?.should == false
    end
  end

  describe "#failed?" do
    it "returns true iff execution_result[:status] is failed" do
      subject.should_receive(:execution_result) { {:status => "failed"} }
      subject.failed?.should == true
    end

    it "returns false" do
      subject.should_receive(:execution_result) { {} }
      subject.failed?.should == false
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

  describe "#[]" do
    it "should delegate to instance method if it exists" do
      subject.stub(:some_method) { nil }
      subject.stub(:metadata) { nil }
      subject.should_receive(:some_method)
      subject.should_not_receive(:metadata)
      subject[:some_method]
    end

    it "should delegate to metadata if no method exists" do
      subject.should_not respond_to(:some_method)
      subject.metadata.stub(:[]) { nil }
      subject.metadata.should_receive(:[]).with(:some_method)
      subject[:some_method]
    end
  end
end
