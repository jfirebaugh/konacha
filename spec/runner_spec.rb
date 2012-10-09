require 'spec_helper'

describe Konacha::Runner do
  before do
    Konacha.mode = :runner
    Konacha.config.driver = :selenium_with_firebug
    STDOUT.stub(:puts)
  end

  describe "#run" do
    let(:suite) do
      {'event' => 'suite',
       'type' => 'suite',
       'data' => {
         'title' => 'failure',
         'fullTitle' => 'failure'
       }}
    end

    let(:suite_end) do
      {'event' => 'suite end',
       'type' => 'suite',
       'data' => {
         'title' => 'failure',
         'fullTitle' => 'failure'
       }}
    end

    let(:test) do
      {'event' => 'test',
       'type'  => 'test',
       'data'  => {
         'title'           => 'fails',
         'fullTitle'       => 'failure fails',
         'parentFullTitle' => 'failure'}}
    end

    let(:failure) do
      {'event' => 'fail',
       'type'  => 'test',
       'data'  => {
         'title'           => 'fails',
         'fullTitle'       => 'failure fails',
         'parentFullTitle' => 'failure',
         'status'          => 'failed',
         'error'           => {'message' => 'expected 4 to equal 5', 'expected' => 5}}}
    end

    let(:pass) do
      {'event' => 'pass',
       'type'  => 'test',
       'data'  => {
         'title'           => 'is empty',
         'fullTitle'       => 'the body#konacha element is empty',
         'parentFullTitle' => 'the body#konacha element',
         'status'          => 'passed',
         'duration'        => anything}}
    end

    let(:pending) do
      {'event' => 'pending',
       'type'  => 'test',
       'data'  => {
         'title'           => 'is pending',
         'fullTitle'       => 'pending test is pending',
         'parentFullTitle' => 'pending test',
         'status'          => 'pending'}}
    end

    it "passes along the right events" do
      subject.reporter.should_receive(:process_mocha_event).with(suite)
      subject.reporter.should_receive(:process_mocha_event).with(suite_end)
      subject.reporter.should_receive(:process_mocha_event).with(test)
      subject.reporter.should_receive(:process_mocha_event).with(failure)
      subject.reporter.should_receive(:process_mocha_event).with(pass)
      subject.reporter.should_receive(:process_mocha_event).with(pending)
      subject.reporter.should_receive(:process_mocha_event).any_number_of_times
      subject.run
    end
  end
end
