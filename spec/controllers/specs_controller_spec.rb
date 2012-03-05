require 'spec_helper'

describe Konacha::SpecsController do
  before do
    @routes = Konacha::Engine.routes
  end

  describe "#set_interface" do
    it "assigns Konacha.interface to @interface" do
      Konacha.should_receive(:interface) { :tdd }
      subject.set_interface
      assigns[:interface].should == :tdd
    end
  end

  describe "#set_mode" do
    it "assigns Konacha.mode to @mode" do
      Konacha.should_receive(:mode) { :runner }
      subject.set_mode
      assigns[:mode].should == :runner
    end
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
