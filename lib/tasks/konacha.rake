namespace :konacha do
  desc "Run JavaScript specs interactively"
  task :serve => :environment do
    Konacha.serve
  end

  desc "Run JavaScript specs non-interactively"
  task :run => :environment do
    Konacha.run
  end
end
