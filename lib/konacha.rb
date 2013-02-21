require "tilt"
require "konacha/engine"
require "konacha/runner"
require "konacha/server"
require "konacha/reporter"
require "konacha/formatter"

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

    delegate :port, :spec_dir, :spec_matcher, :application, :driver, :runner_port, :to => :config

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

    def mounted?
      !!mount_path
    end

    def mount_path
      @mount_path ||= Rails.application.routes.routes.find{|r| r.app == Konacha::Engine }.try(:path).try(:spec).to_s
    end
  end
end
