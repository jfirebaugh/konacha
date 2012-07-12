module Konacha
  class FixturesController < ActionController::Base
    def fixtures
      render  :file => "#{Rails.root}#{request.env['REQUEST_PATH']}"
      rescue ActionView::MissingTemplate
        render :text => "Not found", :status => 404
    end
  end
end
