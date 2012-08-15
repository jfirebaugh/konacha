module Konacha
  class Engine < Rails::Engine
    # Do not mess up the application's namespace.
    # http://api.rubyonrails.org/classes/Rails/Engine.html#label-Isolated+Engine
    isolate_namespace Konacha

    config.konacha = ActiveSupport::OrderedOptions.new

    def self.application(app)
      Rack::Builder.app do
        use Rack::ShowExceptions
        use ActionDispatch::Reloader

        map app.config.assets.prefix do
          run app.assets
        end

        map "/" do
          run Engine
        end
      end
    end

    def options(app)
      options = app.config.konacha
      options.spec_dir    ||= "spec/javascripts"
      options.port        ||= 3500
      options.driver      ||= :selenium
      options
    end

    initializer 'konacha.autoload', :before => :set_autoload_paths do |app|
      app.config.autoload_paths << app.root.join(options(app).spec_dir).to_s
    end

    initializer "konacha.environment" do |app|
      unless app.config.assets.enabled
        raise RuntimeError, "Konacha requires the asset pipeline to be enabled"
      end

      app.config.assets.paths << app.root.join(options(app).spec_dir).to_s
    end
  end
end
