require 'spec_helper'

describe Konacha::SpecsController do
  before do
    @routes = Konacha::Engine.routes
  end

  describe "#iframe" do
    it "assigns the result of Spec.find to @specs" do
      Konacha::Spec.should_receive(:find).with("spec_path") { :spec }
      get :iframe, :path => "spec_path"
      assigns[:specs].should == :spec
    end

    it "404s if there is no match for the given path" do
      Konacha::Spec.should_receive(:find).with("array_spec") { raise Konacha::Spec::NotFound }
      get :iframe, :path => "array_spec"
      response.status.should == 404
      response.should_not render_template("konacha/specs/iframe")
    end
  end
end
