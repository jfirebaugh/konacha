require "capybara"
require "colorize"

module Konacha
  class Runner
    def self.start
      new.run
    end

    attr_reader :io, :examples

    def initialize(options = {})
      @io = options[:output] || STDOUT
    end

    def run
      before = Time.now

      begin
        session.visit("/")

        dots_printed = 0
        begin
          sleep 0.1
          done, dots = session.evaluate_script('[Konacha.done, Konacha.dots]')
          if dots
            io.write colorize_dots(dots[dots_printed..-1])
            io.flush
            dots_printed = dots.length
          end
        end until done

        @examples = JSON.parse(session.evaluate_script('Konacha.getResults()')).map do |row|
          Example.new(row)
        end
      rescue => e
        raise e, "Error communicating with browser process: #{e}", e.backtrace
      end

      io.puts ""
      io.puts ""
      failure_messages.each { |msg| io.write("#{msg}\n\n") }

      seconds = "%.2f" % (Time.now - before)
      io.puts "Finished in #{seconds} seconds"
      io.puts "#{examples.size} examples, #{failed_examples.size} failures, #{pending_examples.size} pending"
      passed?
    end

    def pending_examples
      examples.select { |example| example.pending? }
    end

    def failed_examples
      examples.select { |example| example.failed? }
    end

    def passed?
      examples.all? { |example| example.passed? || example.pending? }
    end

    def failure_messages
      examples.map { |example| example.failure_message }.compact
    end

    def session
      @session ||= Capybara::Session.new(Konacha.driver, Konacha.application)
    end

    def colorize_dots(dots)
      dots = dots.chars.map do |d|
        case d
        when 'E', 'F'; d.red
        when 'P'; d.yellow
        when '.'; d.green
        else;     d
        end
      end
      dots.join ''
    end
  end

  class Example
    def initialize(row)
      @row = row
    end

    def passed?
      @row['passed']
    end

    def pending?
      @row['pending']
    end

    def failed?
      !(@row['passed'] || @row['pending'])
    end

    def failure_message
      if failed?
        msg = []
        msg << "  Failed: #{@row['name']}"
        msg << "    #{@row['message']}"
        msg << "    in #{@row['trace']['fileName']}:#{@row['trace']['lineNumber']}" if @row['trace']
        msg.join("\n").red
      elsif pending?
        "  Pending: #{@row['name']}".yellow
      end
    end
  end
end
