namespace :konacha do
  desc "Run JavaScript specs interactively"
  task :server => :environment do
    Konacha.serve
  end

  desc "Run JavaScript specs non-interactively"
  task :ci => :environment do
    Konacha.run
  end
end
