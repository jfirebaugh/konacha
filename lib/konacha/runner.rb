require "capybara"

module Konacha
  class Runner
    def self.start
      new.run
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
          msg << "    in #{@row['trace']['fileName']}:#{@row['trace']['lineNumber']}" if @row['trace']
          msg.join("\n")
        end
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
        run_examples!
        io.puts failure_messages.join("\n\n")
        io.puts "\n#{examples.size} examples, #{failed_examples.size} failures"
        passed?
      end

      def run_examples!
        session.visit(spec.url)

        previous_results = ""

        session.wait_until(300) do
          dots = session.evaluate_script('Konacha.dots')
          io.print dots.sub(/^#{Regexp.escape(previous_results)}/, '')
          io.flush
          previous_results = dots
          session.evaluate_script('Konacha.done')
        end

        dots = session.evaluate_script('Konacha.dots')
        io.print dots.sub(/^#{Regexp.escape(previous_results)}/, '')

        @examples = JSON.parse(session.evaluate_script('Konacha.getResults()')).map do |row|
          Example.new(row)
        end
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
    end

    attr_reader :suite, :io

    def initialize(options = {})
      @io = options[:output] || STDOUT
    end

    def spec_runner(spec)
      SpecRunner.new(self, spec)
    end

    def run
      before = Time.now

      spec_runners.each { |spec_runner| spec_runner.run_examples! } # prints dots
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
      spec_runners.all? { |spec_runner| spec_runner.passed? }
    end

    def failure_messages
      examples.map { |example| example.failure_message }.compact
    end

    def session
      @session ||= Capybara::Session.new(Konacha.driver, Konacha.application)
    end

  protected

    def spec_runners
      @spec_runners ||= Konacha::Spec.all.map { |spec| SpecRunner.new(self, spec) }
    end
  end
end
