module Konacha
  class SpecsController < ActionController::Base
    before_filter :set_interface, :set_mode

    def set_interface
      @interface = Konacha.interface
    end

    def set_mode
      @mode = Konacha.mode
    end

    def index
      @specs = Konacha::Spec.all
    end

    def show
      @spec = Konacha::Spec.find(params[:spec])
      @spec or render :text => "Not Found", :status => 404
    end
  end
end
