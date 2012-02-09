namespace :matcha do
  desc "Run JavaScript specs interactively"
  task :server => :environment do
    Matcha.serve
  end

  desc "Run JavaScript specs non-interactively"
  task :ci => :environment do
    Matcha.run
  end
end
