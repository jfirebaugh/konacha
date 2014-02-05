require 'spec_helper'

describe Konacha::Reporter::ExampleGroup do
  subject { described_class.new({}, nil) }

  describe "#initialize" do
    it "loads up a metadata instance and the parent" do
      data = double('data')
      parent_metadata = Konacha::Reporter::Metadata.new({})
      parent = double('parent', metadata: parent_metadata)

      # Check if parent metadata is added to metadata
      described_class.any_instance.stub(:update_metadata) { nil }
      described_class.any_instance.should_receive(:update_metadata).with(example_group: parent_metadata)

      example_group = described_class.new(data, parent)
      example_group.parent.should == parent
      example_group.metadata.should be_a(Konacha::Reporter::Metadata)
      example_group.metadata.data.should == data
    end
  end

  describe "delegated methods" do
    let(:metadata) { double('metadata') }
    before { Konacha::Reporter::Metadata.stub(:new) { metadata } }

    [:full_description, :description, :file_path, :described_class].each do |method|
      it "delegates #{method} to metadata" do
        metadata.should_receive(method)
        subject.send(method)
      end
    end
  end

  describe "aliased_methods" do
    it "aliases display_name to description" do
      subject.display_name.should == subject.description
    end
  end

  describe "#parent_groups" do
    let(:parent) { double('parent') }
    let(:grandparent) { double('grandparent') }

    before do
      grandparent.stub(:parent => nil)
      parent.stub(:parent => grandparent)
      subject.stub(:parent => parent)
    end

    it "finds all of this group's ancestors" do
      subject.parent_groups.should == [parent, grandparent]
    end

    it "works via #ancestors" do
      subject.ancestors.should == [parent, grandparent]
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
