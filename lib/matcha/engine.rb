module Matcha
  class Engine < Rails::Engine
    config.matcha = ActiveSupport::OrderedOptions.new

    def self.application(app)
      Rack::Builder.app do
        map app.config.assets.prefix do
          run app.assets
        end

        run Matcha::Engine
      end
    end

    initializer "matcha.environment" do |app|
      unless app.config.assets.enabled
        raise RuntimeError, "matcha requires the asset pipeline to be enabled"
      end

      options = app.config.matcha

      options.spec_dir    ||= "spec/javascripts"
      options.port        ||= 8888
      options.interface   ||= :bdd
      options.application ||= self.class.application(app)
      options.driver      ||= :selenium

      app.config.assets.paths << app.root.join(options.spec_dir).to_s
    end
  end
end
