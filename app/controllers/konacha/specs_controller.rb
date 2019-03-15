module Konacha
  class SpecsController < ActionController::Base
    rescue_from Konacha::Spec::NotFound do
      if Konacha.rails_5_x?
        render plain: "Not found", status: 404
      else
        render :text => "Not found", :status => 404
      end
    end

    def parent
      @run_mode = params.fetch(:mode, Konacha.mode).to_s.inquiry
      @specs = Konacha::Spec.all(params[:path])
    end

    def iframe
      @spec = Konacha::Spec.find_by_name(params[:name])
      @stylesheets = Konacha::Engine.config.konacha.stylesheets
      @javascripts = Konacha::Engine.config.konacha.javascripts
    end
  end
end
