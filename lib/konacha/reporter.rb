require "konacha/reporter/example"
require "konacha/reporter/example_group"

# The Konacha Reporter implements the same protocol as the RSpec Reporter.
# More details on the RSpec Reporter protocol are available in the rspec-core
# repository: https://github.com/rspec/rspec-core/blob/1852a7f4221c5731e108484cb2debfbaca60b283/lib/rspec/core/formatters/base_formatter.rb#L8-L25

module Konacha
  class Reporter
    EVENT_CONVERSIONS = {
      'suite'     => :example_group_started,
      'test'      => :example_started,
      'pass'      => :example_passed,
      'fail'      => :example_failed,
      'pending'   => :example_pending,
      'suite end' => :example_group_finished,
    }

    attr_reader :start_time, :duration, :example_count, :failure_count, :pending_count

    def initialize(*formatters)
      @formatters = formatters
      @example_count = @failure_count = @pending_count = 0
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
        process_event :dump_summary, @duration, @example_count, @failure_count, @pending_count
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
      @failure_count == 0
    end

    def process_mocha_event(event)
      if event['event'] == 'start'
        start(event['testCount'])
      elsif event['event'] == 'end'
        finish
      elsif event['type']
        object = update_or_create_object(event['data'], event['type'])
        process_event EVENT_CONVERSIONS[event['event']], object
      end
    end

    def process_event(method, *args, &block)
      case method
        when :example_started
          @example_count += 1
        when :example_failed
          @failure_count += 1
        when :example_pending
          @pending_count += 1
      end

      @formatters.each do |formatter|
        formatter.send method, *args, &block
      end
    end

    def update_or_create_object(data, type)
      collection = type == 'test' ? @examples : @groups
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
  end
end
