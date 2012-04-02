require 'spec_helper'

describe Konacha do
  describe ".config" do
    subject { Konacha.config }

    describe ".spec_dir" do
      it "defaults to 'spec/javascripts'" do
        subject.spec_dir.should == "spec/javascripts"
      end
    end
  end

  describe ".spec_paths" do
    subject { Konacha.spec_paths }

    it "returns an array of paths relative to spec_dir" do
      subject.should include("array_sum_js_spec.js")
      subject.should include("array_sum_cs_spec.js.coffee")
    end

    it "includes subdirectories" do
      subject.should include("subdirectory/subdirectory_spec.js")
    end

    it "does not include spec_helper" do
      subject.should_not include("spec_helper.js")
    end
  end

  it "can be configured in an initializer" do
    Konacha.config.configured.should == true
  end
end
