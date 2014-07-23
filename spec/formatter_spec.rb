require 'spec_helper'

describe Konacha::Formatter do
  let(:io) { StringIO.new }
  subject { described_class.new(io) }

  shared_examples 'test result' do |method, dot|
    it 'stores the example in the examples array' do
      subject.send(method, nil)
      expect(subject.examples).to be_present
    end

    it 'outputs the dot' do
      subject.send(method, nil)
      io.rewind
      expect(io.read).to eql(dot)
    end

    it 'uses colors when tty' do
      allow(io).to receive(:tty?).and_return(true)
      subject.send(method, nil)
      io.rewind
      expect(io.read).to match(/\e\[0;\d{2};49m#{dot}\e\[0m/)
    end
  end

  describe '#example_passed' do
    it_behaves_like 'test result', :example_passed, '.'
  end

  describe '#example_failed' do
    it_behaves_like 'test result', :example_failed, 'F'
  end

  describe '#example_pending' do
    it_behaves_like 'test result', :example_pending, 'P'
  end

  describe '#dump_pending' do
    let(:example) { double('example', :pending? => true, :full_description => 'Pending example') }
    before { subject.stub(:examples => [example]) }

    it 'outputs the pending message' do
      subject.dump_pending
      io.rewind
      expect(io.read).to include('  Pending: Pending example')
    end
  end

  describe '#dump_failures' do
    let(:example) do
      double('example',
             :failed?            => true,
             :full_description   => 'Failed example',
             :exception          => double('exception',
                                           :message   => 'exception',
                                           :backtrace => nil))
    end

    before { subject.stub(:examples => [example]) }

    it 'outputs the failure message' do
      subject.dump_failures
      io.rewind
      expect(io.read).to include("  Failed: Failed example\n    exception")
    end
  end

  describe '#dump_summary' do
    it 'outputs the summary' do
      subject.dump_summary(10, 10, 2, 3)
      io.rewind
      expect(io.read).to eql "\nFinished in 10.00 seconds\n10 examples, 2 failed, 3 pending\n"
    end
  end
end
