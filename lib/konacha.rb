require "tilt"
require "konacha/engine"
require "konacha/runner"
require "konacha/server"
require "konacha/reporter"
require "konacha/formatter"
require "konacha/option_parser"

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

    def configure_custom_formatters(formatter_names)
      config.formatters = formatter_names.map do |formatter_name|
        formatter_name.constantize.new(STDOUT)
      end
    end

    delegate :port, :spec_dir, :spec_matcher, :application, :driver, :runner_port, :formatters, :to => :config

    def spec_root
      File.join(Rails.root, config.spec_dir)
    end

    def spec_paths
      Rails.application.assets.each_entry(spec_root).find_all { |pathname|
        config.spec_matcher === pathname.basename.to_s &&
        (pathname.extname == '.js' || Tilt[pathname]) &&
        Rails.application.assets.content_type_of(pathname) == 'application/javascript'
      }.map { |pathname|
        pathname.to_s.gsub(File.join(spec_root, ''), '')
      }.sort
    end
  end
end
