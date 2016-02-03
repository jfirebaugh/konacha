module Konacha
  class Engine < ::Rails::Engine
    # Do not mess up the application's namespace.
    # http://api.rubyonrails.org/classes/Rails/Engine.html#label-Isolated+Engine
    isolate_namespace Konacha

    config.konacha = ActiveSupport::OrderedOptions.new

    def self.application(app)
      app.config.cache_classes = false
      sprockes_env = Sprockets::Railtie.build_environment(app)

      Rack::Builder.app do
        use Rack::ShowExceptions

        map app.config.assets.prefix do
          run sprockes_env
        end

        map "/" do
          run Engine
        end
      end
    end

    def self.formatters
      if ENV['FORMAT']
        ENV['FORMAT'].split(',').map do |string|
          eval(string).new(STDOUT)
        end
      else
        [Konacha::Formatter.new(STDOUT)]
      end
    end

    initializer "konacha.environment" do |app|
      options = app.config.konacha

      options.spec_dir     ||= "spec/javascripts"
      options.spec_matcher ||= /_spec\.|_test\./
      options.port         ||= 3500
      options.host         ||= 'localhost'
      options.driver       ||= :selenium
      options.stylesheets  ||= %w(application)
      options.javascripts  ||= %w(chai konacha/iframe)
      options.verbose      ||= false
      options.runner_port  ||= nil
      options.formatters   ||= self.class.formatters

      spec_dirs = [options.spec_dir].flatten
      app.config.assets.paths += spec_dirs.map{|d| app.root.join(d).to_s}
      options.application  ||= self.class.application(app)
    end

    config.after_initialize do
      ActiveSupport.on_load(:action_view) do
        default_checker = ActionView::Base.precompiled_asset_checker
        ActionView::Base.precompiled_asset_checker = -> logical_path do
          default_checker[logical_path] || Konacha.asset_precompiled?(logical_path)
        end
      end
    end
  end
end
