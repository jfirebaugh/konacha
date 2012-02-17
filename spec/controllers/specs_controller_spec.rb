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

  describe "#index" do
    it "assigns Konacha::Spec.all to @specs" do
      Konacha::Spec.should_receive(:all) { :all }
      get :index
      assigns[:specs].should == :all
    end
  end

  describe "#show" do
    it "finds the spec with the given basename and assigns it to @spec" do
      Konacha::Spec.should_receive(:find).with("array_spec") { :spec }
      get :show, :spec => "array_spec"
      assigns[:spec].should == :spec
    end

    it "404s if there is no spec with the given basename" do
      Konacha::Spec.should_receive(:find).with("array_spec") { nil }
      get :show, :spec => "array_spec"
      response.status.should == 404
      response.should_not render_template("konacha/specs/show")
    end
  end
end
