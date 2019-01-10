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
      puts "  http://#{host}:#{port}/"
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

    delegate :host, :port, :spec_dir, :spec_matcher, :application, :driver,
             :runner_host, :runner_port, :formatters, :to => :config

    def spec_root
      [config.spec_dir].flatten.map {|d| File.join(Rails.root, d)}
    end

    def spec_paths
      spec_root.flat_map do |root|
        # Support Sprockets 2.x
        if Rails.application.assets.respond_to?(:each_entry)
          paths = Rails.application.assets.each_entry(root).find_all { |pathname|
            config.spec_matcher === pathname.basename.to_s &&
            (pathname.extname == '.js' || Tilt[pathname]) &&
            Rails.application.assets.content_type_of(pathname) == 'application/javascript'
          }
        # Sprockets 3
        elsif Rails.application.assets.respond_to?(:each_file)
          paths = Rails.application.assets.each_file.find_all { |path|
            pathname = Pathname.new(path)
            pathname.dirname.to_s.start_with?(root) &&
              config.spec_matcher === pathname.basename.to_s &&
              (pathname.extname == '.js' || Tilt[pathname])
          }
        else
          raise NotImplementedError.new("Konacha is not compatible with the version of Sprockets used by your application.")
        end
        paths.map { |pathname|
          pathname.to_s.gsub(File.join(root, ''), '')
        }.sort
      end
    end

    def precompiled_assets
      %W(konacha.css
         chai.js
         mocha.js
         konacha/parent.js
         konacha/iframe.js
         konacha/runner.js).concat(spec_paths).map do |path|
        path.gsub(/\.js\.coffee$/, ".js").gsub(/\.coffee$/, ".js")
      end
    end

    def asset_precompiled?(logical_path)
      precompiled_assets.include? logical_path
    end

    def sprockets_rails_3?
      defined?(Sprockets::Rails::VERSION) && Sprockets::Rails::VERSION.start_with?('3')
    end
  end
end
