require "colorize"

module Konacha
  class Formatter
    attr_reader :io, :examples

    def initialize(io)
      @io = io
      @examples = []
    end

    def start(expected_example_count=nil); end
    def example_group_started(group); end
    def example_started(example); end

    def example_passed(example)
      @examples << example
      io.write(".".green)
    end

    def example_failed(example)
      @examples << example
      io.write("F".red)
    end

    def example_pending(example)
      @examples << example
      io.write("P".yellow)
    end

    def example_group_finished(group); end
    def stop; end

    def start_dump
      io.puts ""
    end

    def dump_pending
      pending_examples = examples.select(&:pending?)
      if pending_examples.present?
        io.puts ""
        io.puts(pending_examples.map {|example| pending_message(example)}.join("\n\n"))
      end
    end

    def dump_failures
      failed_examples = examples.select(&:failed?)
      if failed_examples.present?
        io.puts ""
        io.puts(failed_examples.map {|example| failure_message(example)}.join("\n\n"))
      end
    end

    def dump_summary(duration, example_count, failure_count, pending_count)
      seconds = "%.2f" % duration
      io.puts ""
      io.puts "Finished in #{seconds} seconds"
      io.puts "#{example_count} examples, #{failure_count} failed, #{pending_count} pending"
    end

    def seed(seed); end

    def close
      io.close
    end

    private
    def failure_message(example)
      msg = []
      msg << "  Failed: #{example.full_description}"
      msg << "    #{example.exception.message}"
      msg << "    in #{example.exception.backtrace.first}" if example.exception.backtrace.present?
      msg.join("\n").red
    end

    def pending_message(example)
      "  Pending: #{example.full_description}".yellow
    end
  end
end
