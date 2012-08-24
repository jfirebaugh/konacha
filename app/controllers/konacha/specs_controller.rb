module Konacha
  class SpecsController < ActionController::Base
    rescue_from Konacha::Spec::NotFound do
      render :text => "Not found", :status => 404
    end

    def reporter
      @iframe_path = runner_path + request.fullpath
    end

    def specs
      @specs = Konacha::Spec.find(params[:path] || "")
      @stylesheets = Konacha::Engine.config.konacha.stylesheets
    end
  end
end
