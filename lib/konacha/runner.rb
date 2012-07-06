require "capybara"

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
      io.puts "#{examples.size} examples, #{failed_examples.size} failures"
      passed?
    end

    def examples
      spec_runners.map { |spec_runner| spec_runner.examples }.flatten
    end

    def failed_examples
      examples.select { |example| not example.passed? }
    end

    def passed?
      examples.all? { |example| example.passed? }
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

    def run
      session.visit(spec.url)

      dots_printed = 0
      begin
        sleep 0.1
        done, dots = session.evaluate_script('[Konacha.done, Konacha.dots]')
        if dots
          io.write dots[dots_printed..-1]
          io.flush
          dots_printed = dots.length
        end
      end until done

      @examples = JSON.parse(session.evaluate_script('Konacha.getResults()')).map do |row|
        Example.new(row)
      end
    rescue => e
      raise Konacha::Error, "Error communicating with browser process: #{e.inspect}"
    end
  end

  class Example
    def initialize(row)
      @row = row
    end

    def passed?
      @row['passed']
    end

    def failure_message
      unless passed?
        msg = []
        msg << "  Failed: #{@row['name']}"
        msg << "    #{@row['message']}"
        msg << failure_additional_info
        msg.compact.join("\n")
      end
    end

    def failure_additional_info
      trace = @row['trace'] || {}
      if trace =~ /timeout of [\d\.]+ms exceeded/
        "Execution of spec took too long (or forgot to call done())"
      elsif trace['fileName'].present?
        # TODO: Investigate if mocha even returns errors with fileName and 
        #       lineNumber
        #
        #      - I've seen @row["trace"] coming back as a straight strings
        #         instead of hashes
        "    in: #{[trace['fileName'],trace['lineNumber']].compact.join(":")}"
      end
    end
  end

  class Error < StandardError
  end
end
