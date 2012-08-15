require "tilt"
require "konacha/engine"
require "konacha/runner"
require "konacha/server"

module Konacha
  class << self
    attr_accessor :mode

    def serve
      puts "Your tests are here:"
      puts "  http://localhost:#{port}/"
      self.mode = :server
      Konacha::Server.start
    end

    def run
      self.mode = :runner
      Konacha::Runner.start
    end

    def config
      Konacha::Engine.config.konacha
    end

    def configure
      yield config
    end

    delegate :port, :spec_dir, :driver, :to => :config

    def application
      Konacha::Engine.application(Rails.application)
    end

    def spec_root
      File.join(Rails.root, config.spec_dir)
    end

    def spec_paths
      Rails.application.assets.each_entry(spec_root).find_all { |pathname|
        pathname.basename.to_s =~ /_spec\.|_test\./ &&
        (pathname.extname == '.js' || Tilt[pathname]) &&
        Rails.application.assets.content_type_of(pathname) == 'application/javascript'
      }.map { |pathname|
        pathname.to_s.gsub(File.join(spec_root, ''), '')
      }
    end

    def ruby_fixtures_json
      begin
        # Try to autoload.
        # http://stackoverflow.com/questions/11973369/defined-for-autoloadable-classes
        RubyFixtures
      rescue NameError
        return nil.to_json
      end
      RubyFixtures.fixtures.to_json
    end
  end
end
