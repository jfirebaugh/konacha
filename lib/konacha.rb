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

    delegate :port, :spec_dir, :application, :driver, :to => :config

    def spec_root
      File.join(Rails.root, config.spec_dir)
    end

    def spec_paths
      Rails.application.assets.each_file.find_all { |pathname|
        pathname.to_s.start_with?(spec_root) &&
        pathname.basename.to_s =~ /_spec\.|_test\./ &&
        (pathname.extname == '.js' || Tilt[pathname]) &&
        Rails.application.assets.content_type_of(pathname) == 'application/javascript'
      }.map { |pathname|
        pathname.to_s.gsub(File.join(spec_root, ''), '')
      }
    end
  end
end
