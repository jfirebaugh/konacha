require 'spec_helper'

describe Konacha::FixturesController do
  before do
    @routes = Konacha::Engine.routes
  end

  describe "#fixtures" do
    it "assigns the result of Spec.find to @specs" do
      get :fixtures, :path => "test.html"
      response.should be_success
    end

    it "404s if there is no match for the given path" do
      get :fixtures, :path => "not_there.html"
      response.status.should == 404
    end
  end
end
