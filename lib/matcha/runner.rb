module Matcha
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
      attr_reader :runner, :spec

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
        io.puts dots
        io.puts failure_messages
        io.puts "\n#{examples.size} examples, #{failed_examples.size} failures"
        passed?
      end

      def examples
        @results ||= begin
          session.visit(spec.url)

          previous_results = ""

          session.wait_until(300) do
            dots = session.evaluate_script('Matcha.dots')
            io.print dots.sub(/^#{Regexp.escape(previous_results)}/, '')
            io.flush
            previous_results = dots
            session.evaluate_script('Matcha.done')
          end

          dots = session.evaluate_script('Matcha.dots')
          io.print dots.sub(/^#{Regexp.escape(previous_results)}/, '')

          JSON.parse(session.evaluate_script('Matcha.getResults()')).map do |row|
            Example.new(row)
          end
        end
      end

      def failed_examples
        examples.select { |example| not example.passed? }
      end

      def passed?
        examples.all? { |example| example.passed? }
      end

      def dots
        examples; ""
      end

      def failure_messages
        unless passed?
          examples.map { |example| example.failure_message }.compact.join("\n\n")
        end
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

      io.puts ""
      io.puts dots.to_s
      io.puts ""
      if failure_messages
        io.puts failure_messages
        io.puts ""
      end

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

    def dots
      spec_runners.map { |spec_runner| spec_runner.dots }.join
    end

    def failure_messages
      unless passed?
        spec_runners.map { |spec_runner| spec_runner.failure_messages }.compact.join("\n\n")
      end
    end

    def session
      @session ||= Capybara::Session.new(Matcha.driver, Matcha.application)
    end

  protected

    def spec_runners
      @spec_runners ||= Matcha::Spec.all.map { |spec| SpecRunner.new(self, spec) }
    end
  end
end
