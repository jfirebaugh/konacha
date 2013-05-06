require "konacha/reporter/example"
require "konacha/reporter/example_group"

# The Konacha Reporter implements the same protocol as the RSpec Reporter.
# More details on the RSpec Reporter protocol are available in the rspec-core
# repository: https://github.com/rspec/rspec-core/blob/1852a7f4221c5731e108484cb2debfbaca60b283/lib/rspec/core/formatters/base_formatter.rb#L8-L25

module Konacha
  class Reporter
    attr_reader :start_time, :duration, :examples

    def initialize(*formatters)
      @formatters = formatters
      @duration = @start_time = nil
      @examples, @groups = {}, {}
    end

    def start(expected_example_count=nil)
      @start_time = Time.now
      process_event :start, expected_example_count
    end

    def finish(seed=nil)
      begin
        stop
        process_event :start_dump
        process_event :dump_pending
        process_event :dump_failures
        process_event :dump_summary, duration, example_count, failure_count, pending_count
        process_event :seed, seed if seed
      ensure
        process_event :close
      end
    end

    def stop
      @duration = Time.now - @start_time if @start_time
      process_event :stop
    end

    def passed?
      failure_count == 0
    end

    def process_mocha_event(event)
      if event['event'] == 'start'
        handle_mocha_start event
      elsif event['event'] == 'end'
        handle_mocha_end event
      elsif event['type']
        event_name = event['event'].tr(' ', '_')
        send "handle_mocha_#{event_name}", event
      end
    end

    def example_count
      examples.count
    end

    def failure_count
      examples.values.count { |example| example.failed? }
    end

    def pending_count
      examples.values.count { |example| example.pending? }
    end

    def process_event(method, *args, &block)
      @formatters.each do |formatter|
        formatter.send method, *args, &block
      end
    end

    def update_or_create_object(data, type)
      collection = type == 'test' ? examples : @groups
      object = collection[data['fullTitle']]
      if object
        object.update_metadata(data)
      else
        klass  = type == 'test' ? Example : ExampleGroup
        parent = @groups[data['parentFullTitle']]
        object = collection[data['fullTitle']] = klass.new(data, parent)
      end

      object
    end

    private
    def event_object(event)
      update_or_create_object(event['data'], event['type'])
    end

    def handle_mocha_start(event)
      start(event['testCount'])
    end

    def handle_mocha_end(event)
      finish
    end

    def handle_mocha_suite(event)
      process_event :example_group_started, event_object(event)
    end

    def handle_mocha_test(event)
      process_event :example_started, event_object(event)
    end

    def handle_mocha_pass(event)
      process_event :example_passed, event_object(event)
    end

    def handle_mocha_pending(event)
      object = event_object(event)
      # Mocha emits pending without a start event; RSpec emits start, then pending
      process_event :example_started, object
      process_event :example_pending, object
    end

    def handle_mocha_fail(event)
      process_event :example_failed, event_object(event)
    end

    def handle_mocha_suite_end(event)
      process_event :example_group_finished, event_object(event)
    end
  end
end
