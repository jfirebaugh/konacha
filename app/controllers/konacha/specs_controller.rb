module Konacha
  class SpecsController < ActionController::Base
    rescue_from Konacha::Spec::NotFound do
      render :text => "Not found", :status => 404
    end

    def parent
      @run_mode = params.fetch(:mode, Konacha.mode).to_s.inquiry
      @specs = Konacha::Spec.all(params[:path])
    end

    def iframe
      @spec = Konacha::Spec.find_by_name(params[:name])
      @stylesheets = Konacha::Engine.config.konacha.stylesheets
    end
  end
end
