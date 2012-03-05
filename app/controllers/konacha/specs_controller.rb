module Konacha
  class SpecsController < ActionController::Base
    rescue_from Konacha::Spec::NotFound do
      render :text => "Not found", :status => 404
    end

    def specs
      @specs = Konacha::Spec.find(params[:path] || "")
    end
  end
end
