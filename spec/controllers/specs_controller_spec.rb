require 'spec_helper'

describe Konacha::SpecsController do
  before do
    @routes = Konacha::Engine.routes
  end

  describe '#parent' do
    it 'accepts a mode parameter and assigns it to @run_mode' do
      get :parent, :mode => 'runner'
      assigns[:run_mode].should be_runner
    end

    it 'uses the Konacha.mode if no mode parameter is specified' do
      Konacha.stub(:mode => :konacha_mode)
      get :parent
      assigns[:run_mode].should be_konacha_mode
    end
  end

  describe "#iframe" do
    it "assigns the result of Spec.find_by_name to @spec" do
      Konacha::Spec.should_receive(:find_by_name).with("spec_name") { :spec }
      get :iframe, :name => "spec_name"
      assigns[:spec].should == :spec
    end

    it "404s if there is no match for the given path" do
      Konacha::Spec.should_receive(:find_by_name).with("array_spec") { raise Konacha::Spec::NotFound }
      get :iframe, :name => "array_spec"
      response.status.should == 404
      response.should_not render_template("konacha/specs/iframe")
    end
  end
end
