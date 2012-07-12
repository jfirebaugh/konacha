require 'spec_helper'

describe Konacha::FixturesController do
  before do
    @routes = Konacha::Engine.routes
  end

  describe "#fixtures" do
    it "returns a fixture" do
      request.env['REQUEST_PATH'] =  '/spec/javascripts/fixtures/test.html'
      get :fixtures, :path => "test.html"
      response.should be_success
    end

    it "404s if there is no match for the given path" do
      request.env['REQUEST_PATH'] =  '/spec/javascripts/fixtures/not_there.html'
      get :fixtures, :path => "not_there.html"
      response.status.should == 404
    end
  end
end
