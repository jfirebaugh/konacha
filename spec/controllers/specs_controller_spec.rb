require 'spec_helper'

describe Konacha::SpecsController do
  before do
    @routes = Konacha::Engine.routes
  end

  describe "#specs" do
    it "assigns the result of Spec.find to @specs" do
      Konacha::Spec.should_receive(:find).with("spec_path") { :spec }
      get :specs, :path => "spec_path"
      assigns[:specs].should == :spec
    end

    it "404s if there is no match for the given path" do
      Konacha::Spec.should_receive(:find).with("array_spec") { raise Konacha::Spec::NotFound }
      get :specs, :path => "array_spec"
      response.status.should == 404
      response.should_not render_template("konacha/specs/show")
    end
  end
end
