require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'pp'

module Konacha
  class OptionParser

    def self.parse(args)
      options = OpenStruct.new
      opt_parser = ::OptionParser.new do |opts|
        opts.banner = "Usage: rake konacha:run -- [options]"

        opts.separator ""
        opts.separator "Note: the extra '--' is necessary for rake to pass-through the remaining arguments."

        opts.separator ""
        opts.separator "Specific options:"

        opts.on("--spec=spec1,spec2", Array, "List of spec files to run") do |spec_list|
          options.spec = spec_list
        end     

        opts.on("--grep=some_string", "Mocha grep string for pattern-matching specific tests") do |grep_string|
          options.grep_string = grep_string
        end
        
        opts.on("--format=formatter1,formatter2", Array, "List of output formatters") do |formatter_names|
          options.formatters = formatter_names
        end

        opts.separator ""
        opts.separator "Common options:"

        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end
      end

      opt_parser.parse!(args)
      options
    end
  end
end
