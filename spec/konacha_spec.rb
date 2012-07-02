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

    it "doesn't dup paths" do
      subject.should == subject.uniq
    end

    it "traverses symlinked directories" do
      begin
        # Create a directory with specs outside of 'spec/javascripts'.
        Dir.mkdir "spec/dummy/app/external_specs"
        File.new "spec/dummy/app/external_specs/my_spec.js", "w"

        # Symlink it into 'spec/javascripts'.
        File.symlink "../../app/external_specs/", "spec/dummy/spec/javascripts/external_specs"

        subject.should include("external_specs/my_spec.js")

        File.unlink "spec/dummy/spec/javascripts/external_specs"
      rescue NotImplementedError
        # Don't test this on platforms that don't support symlinking.
      end

      File.unlink "spec/dummy/app/external_specs/my_spec.js"
      Dir.unlink "spec/dummy/app/external_specs"
    end

    it "does not include spec_helper" do
      subject.should_not include("spec_helper.js")
    end

    it "includes *_test.* files" do
      subject.should include("file_ending_in_test.js")
    end
  end

  it "can be configured in an initializer" do
    Konacha.config.configured.should == true
  end
end
