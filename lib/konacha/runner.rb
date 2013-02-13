require "capybara"

module Konacha
  class Runner
    def self.start
      Capybara.server_port = Konacha.runner_port
      new.run
    end

    attr_reader :reporter

    def initialize(session = nil)
      @session = session
      @reporter = Konacha::Reporter.new(*formatters)
    end

    def run(path = '/')
      session.visit path

      events_consumed = 0
      done = false
      begin
        sleep 0.1
        events = JSON.parse(session.evaluate_script('window.top.Konacha.getEvents()'))
        if events.present?
          events[events_consumed..-1].each do |event|
            done = true if event['event'] == 'end'
            reporter.process_mocha_event(event)
          end

          events_consumed = events.length
        end
      end until done

      reporter.passed?
    rescue => e
      raise e, "Error communicating with browser process: #{e}", e.backtrace
    end

    def session
      @session ||= Capybara::Session.new(Konacha.driver, Konacha.application)
    end

    private
    def formatters
      if ENV['FORMAT']
        ENV['FORMAT'].split(',').map do |string|
          eval(string).new(STDOUT)
        end
      else
        [Konacha::Formatter.new(STDOUT)]
      end
    end
  end
end
