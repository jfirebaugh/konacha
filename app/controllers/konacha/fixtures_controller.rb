module Konacha
  class FixturesController < ActionController::Base
    def fixtures
      render  :file => "#{Rails.root}/spec/javascripts/fixtures/#{params[:path]}"
      rescue ActionView::MissingTemplate
        render :text => "Not found", :status => 404
    end
  end
end
