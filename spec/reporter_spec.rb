require 'spec_helper'

describe Konacha::Reporter do
  let(:formatter) { double('formatter').as_null_object }
  subject { described_class.new(formatter) }

  describe "#start" do
    it "sets the start time to the current time" do
      subject.start
      subject.start_time.should be_within(1.second).of(Time.now)
    end

    it "processes the start event" do
      subject.should_receive(:process_event).with(:start, nil)
      subject.start
    end
  end

  describe "#finish" do
    it "calls #stop" do
      subject.should_receive(:stop)
      subject.finish
    end

    it "processes events" do
      subject.stub(:stop)
      subject.should_receive(:process_event).with(:start_dump).ordered
      subject.should_receive(:process_event).with(:dump_pending).ordered
      subject.should_receive(:process_event).with(:dump_failures).ordered
      subject.should_receive(:process_event).with(:dump_summary, nil, 0, 0, 0).ordered
      subject.should_receive(:process_event).with(:close).ordered
      subject.finish
    end
  end

  describe "#stop" do
    it "calculates duration" do
      subject.start
      subject.stop
      subject.duration.should_not be_nil
    end

    it "processes the stop event" do
      subject.should_receive(:process_event).with(:stop)
      subject.stop
    end
  end

  describe "#process_mocha_event" do
    it "creates the object" do
      subject.stub(:process_event)
      subject.should_receive(:update_or_create_object).with('data', 'type')
      subject.process_mocha_event({'data' => 'data', 'type' => 'type'})
    end

    it "calls #process_event with the converted event name" do
      object = double('test')
      subject.stub(:update_or_create_object) { object }
      subject.should_receive(:process_event).with(:example_started, object)
      subject.process_mocha_event({'event' => 'test', 'type' => 'test'})
    end
  end

  describe "#process_event" do
    describe "increments counts" do
      it "increments example count" do
        subject.process_event(:example_started)
        subject.example_count.should == 1
      end

      it "increments pending count" do
        subject.process_event(:example_pending)
        subject.pending_count.should == 1
      end

      it "increments failed count" do
        subject.process_event(:example_failed)
        subject.failure_count.should == 1
      end
    end

    it "forwards the call on to the formatters" do
      formatter.should_receive(:example_started).with('arg!')
      subject.process_event(:example_started, 'arg!')
    end
  end

  describe "#update_or_create_object" do
    describe "creates the right type of object" do
      it "creates example if test" do
        subject.update_or_create_object({}, 'test').should be_a(Konacha::Reporter::Example)
      end

      it "creates example_group if suite" do
        subject.update_or_create_object({}, 'suite').should be_a(Konacha::Reporter::ExampleGroup)
      end
    end

    it "updates if the object with same fullTitle exists" do
      data = {'fullTitle' => 'title'}
      object = subject.update_or_create_object(data, 'test')
      object.should_receive(:update_metadata).with(data)
      subject.update_or_create_object(data, 'test').should == object
    end

    it "links up the parent correctly" do
      suite = subject.update_or_create_object({'fullTitle' => 'suite'}, 'suite')
      object = subject.update_or_create_object({'fullTitle' => 'suite awesome', 'parentFullTitle' => 'suite'}, 'test')
      object.parent.should == suite
    end
  end
end
