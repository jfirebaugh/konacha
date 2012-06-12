namespace :konacha do
  desc "Run JavaScript specs interactively"
  task :serve => :environment do
    Konacha.serve
  end

  desc "Run JavaScript specs non-interactively"
  task :run => :environment do
    passed = Konacha.run
    # Apparently there is no canonical way to fail a rake task other than
    # throwing an exception or exiting.
    # http://stackoverflow.com/a/5117457/525872
    exit 1 unless passed
  end
end
