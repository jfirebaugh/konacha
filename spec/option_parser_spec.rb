require 'spec_helper'

describe Konacha::OptionParser do
  describe "'--spec' option" do
    it "parses one value" do
      argv = ["--spec", "spec1"]
      options = Konacha::OptionParser.parse(argv)
      options.spec.should == ["spec1"]
    end
    it "parses two values" do
      argv = ["--spec", "spec1,spec2"]
      options = Konacha::OptionParser.parse(argv)
      options.spec.should == ["spec1", "spec2"]
    end
  end

  describe "'--grep' option" do
    it "parses its value" do
      argv = ["--grep", "a sample string"]
      options = Konacha::OptionParser.parse(argv)
      options.grep_string.should == "a sample string"
    end
  end

  describe "'--format' option" do
    it "parses one value" do
      argv = ["--format", "formatter1"]
      options = Konacha::OptionParser.parse(argv)
      options.formatters.should == ["formatter1"]
    end
    it "parses two values" do
      argv = ["--format", "formatter1,formatter2"]
      options = Konacha::OptionParser.parse(argv)
      options.formatters.should == ["formatter1", "formatter2"]
    end
  end
end
