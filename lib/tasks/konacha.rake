namespace :konacha do
  desc "Run JavaScript specs interactively"
  task :serve => :environment do
    Konacha.serve
  end

  desc "Run JavaScript specs non-interactively"
  task :run => :environment do
    options = Konacha::OptionParser.parse(ARGV)

    Konacha.configure do |config|
      config.spec = options.spec if options.spec
      config.grep_string = options.grep_string if options.grep_string
    end
    Konacha.configure_custom_formatters(options.formatters) if options.formatters

    passed = Konacha.run
    # Apparently there is no canonical way to fail a rake task other than
    # throwing an exception or exiting.
    # http://stackoverflow.com/a/5117457/525872
    exit 1 unless passed
  end
end
