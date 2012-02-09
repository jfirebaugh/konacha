module Matcha
  class SpecsController < ActionController::Base
    before_filter :set_interface, :set_mode

    def set_interface
      @interface = Matcha.interface
    end

    def set_mode
      @mode = Matcha.mode
    end

    def index
      @specs = Matcha::Spec.all
    end

    def show
      @spec = Matcha::Spec.find(params[:spec])
      @spec or render :text => "Not Found", :status => 404
    end
  end
end
