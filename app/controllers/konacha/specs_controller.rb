module Konacha
  class SpecsController < ActionController::Base
    rescue_from Konacha::Spec::NotFound do
      render :text => "Not found", :status => 404
    end

    helper_method :spec_path

    def parent
      @run_mode = params.fetch(:mode, Konacha.mode).to_s.inquiry
      @specs = Konacha::Spec.all(params[:path])
    end

    def iframe
      @spec = Konacha::Spec.find_by_name(params[:name])
      @stylesheets = Konacha::Engine.config.konacha.stylesheets
    end

    protected

    def spec_path(spec_name)
      iframe_path(spec_name).tap do |p|
        if Konacha.mode == :runner && Konacha.mounted?
          p.gsub!(Konacha.mount_path, '')
        end
      end
    end
  end
end
