module Konacha
  class Engine < Rails::Engine
    config.konacha = ActiveSupport::OrderedOptions.new

    def self.application(app)
      Rack::Builder.app do
        map app.config.assets.prefix do
          run app.assets
        end

        map "/" do
          run Konacha::Engine
        end
      end
    end

    initializer "konacha.environment" do |app|
      unless app.config.assets.enabled
        raise RuntimeError, "konacha requires the asset pipeline to be enabled"
      end

      options = app.config.konacha

      options.spec_dir      ||= "spec/javascripts"
      options.port          ||= 3500
      options.application   ||= self.class.application(app)
      options.driver        ||= :selenium
      options.ignore_leaks  ||= false

      app.config.assets.paths << app.root.join(options.spec_dir).to_s
    end
  end
end
