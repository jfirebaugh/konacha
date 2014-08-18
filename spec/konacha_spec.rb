require 'spec_helper'

describe Konacha do
  describe ".config" do
    subject { Konacha.config }

    describe ".spec_dir" do
      it "defaults to 'spec/javascripts'" do
        subject.spec_dir.should == "spec/javascripts"
      end
    end

    describe ".spec_matcher" do
      it "defaults to /_spec\.|_test\./" do
        subject.spec_matcher.should == /_spec\.|_test\./
      end
    end

    describe ".runner_port" do
      it "defaults to nil" do
        subject.runner_port.should == nil
      end
    end

    describe ".formatters" do
      it "defaults to a Konacha::Formatter pointing to STDOUT" do
        Konacha.config.formatters.first.should be_a(Konacha::Formatter)
        Konacha.config.formatters.first.io.should == STDOUT
      end

      context "with custom formatters" do
        before do
          class TestFormatter
            def initialize(io)
            end
          end
          Konacha.configure_custom_formatters(['Konacha::Formatter', 'TestFormatter'])
        end

        after do
          Object.send(:remove_const, :TestFormatter)
          Konacha.configure do |config|
            config.formatters = Konacha::Engine.default_formatters
          end
        end

        it "creates the specified formatters" do
          Konacha.config.formatters.first.should be_a(Konacha::Formatter)
          Konacha.config.formatters.second.should be_a(TestFormatter)
        end
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

    it "only includes JavaScript files" do
      subject.should_not include("do_not_include_spec.png")
    end

    it "does not include non-asset files" do
      subject.should_not include("do_not_include_spec.js.bak")
    end

    describe 'with a custom matcher' do
      after { Konacha.config.spec_matcher = /_spec\.|_test\./ }

      it "includes *-spec.* files" do
        Konacha.config.spec_matcher = /-spec\./
        subject.should include("file-with-hyphens-spec.js")
      end

      it "includes *.spec.* files" do
        Konacha.config.spec_matcher = /\.spec\./
        subject.should include("file.with.periods.spec.js")
      end

      it "works with any object responding to ===" do
        Konacha.config.spec_matcher = Module.new do
          def self.===(path)
            path == "array_sum_js_spec.js"
          end
        end
        subject.should include("array_sum_js_spec.js")
        subject.size.should == 1
      end
    end
  end

  it "can be configured in an initializer" do
    Konacha.config.configured.should == true
  end
end
