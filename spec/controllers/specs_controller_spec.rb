require 'spec_helper'

describe Konacha::SpecsController do
  before do
    @routes = Konacha::Engine.routes
  end

  describe '#parent' do
    it 'accepts a mode parameter and assigns it to @run_mode' do
      if Konacha.rails_5_x?
        get :parent, params: { mode: 'runner' }
      else
        get :parent, mode: 'runner'
      end
      assigns[:run_mode].runner?.should be_truthy
    end

    it 'uses the Konacha.mode if no mode parameter is specified' do
      Konacha.stub(:mode => :konacha_mode)
      get :parent
      assigns[:run_mode].konacha_mode?.should be_truthy
    end
  end

  describe "#iframe" do
    it "assigns the result of Spec.find_by_name to @spec" do
      Konacha::Spec.should_receive(:find_by_name).with("spec_name") { :spec }
      if Konacha.rails_5_x?
        get :iframe, params: { name:  "spec_name" }
      else
        get :iframe, name:  "spec_name"
      end
      assigns[:spec].should == :spec
      assigns[:stylesheets].should == Konacha::Engine.config.konacha.stylesheets
      assigns[:javascripts].should == Konacha::Engine.config.konacha.javascripts
    end

    it "404s if there is no match for the given path" do
      Konacha::Spec.should_receive(:find_by_name).with("array_spec") { raise Konacha::Spec::NotFound }
      if Konacha.rails_5_x?
        get :iframe, params: { name: "array_spec" }
      else
        get :iframe, :name => "array_spec"
      end
      response.status.should == 404
      response.should_not render_template("konacha/specs/iframe")
    end
  end
end
