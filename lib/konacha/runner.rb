require "capybara"
require "colorize"

module Konacha
  class Runner
    def self.start
      new.run
    end

    attr_reader :io

    def initialize(options = {})
      @io = options[:output] || STDOUT
    end

    def run
      before = Time.now

      spec_runners.each { |spec_runner| spec_runner.run } # prints dots
      io.puts ""
      io.puts ""
      failure_messages.each { |msg| io.write("#{msg}\n\n") }

      seconds = "%.2f" % (Time.now - before)
      io.puts "Finished in #{seconds} seconds"
      io.puts "#{examples.size} examples, #{failed_examples.size} failures, #{pending_examples.size} pending"
      passed?
    end

    def examples
      spec_runners.map { |spec_runner| spec_runner.examples }.flatten
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

    def spec_runners
      @spec_runners ||= Konacha::Spec.all.map { |spec| SpecRunner.new(self, spec) }
    end
  end

  class SpecRunner
    attr_reader :runner, :spec, :examples

    def initialize(runner, spec)
      @runner = runner
      @spec = spec
    end

    def session
      runner.session
    end

    def io
      runner.io
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

    def run
      session.visit(spec.url)

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
      msg = [e.inspect]
      msg << e.message unless e.message.blank?
      raise Konacha::Error, "Error communicating with browser process:\n#{msg.join("\n")}"
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

  class Error < StandardError
  end
end
