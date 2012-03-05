module Konacha
  class SpecsController < ActionController::Base
    before_filter :set_interface, :set_mode

    rescue_from Konacha::Spec::NotFound do
      render :text => "Not found", :status => 404
    end

    def set_interface
      @interface = Konacha.interface
    end

    def set_mode
      @mode = Konacha.mode
    end

    def specs
      @specs = Konacha::Spec.find(params[:path] || "")
    end
  end
end
