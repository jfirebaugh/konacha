require "konacha/engine"
require "konacha/runner"
require "konacha/server"
require "konacha/spec_bundler"

module Konacha
  class << self
    attr_accessor :mode

    def serve
      puts "your tests are here:"
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

    delegate :port, :spec_dir, :interface, :application, :driver, :to => :config

    def spec_root
      File.join(Rails.root, config.spec_dir)
    end

    def spec_paths
      Dir[File.join(spec_root, "**/*_spec.*")].map do |path|
        path.gsub(File.join(spec_root, ''), '')
      end
    end
  end
end
