namespace :record do
  desc "Run the crawler in Recrod::Retreader mode"
  task :retreader, [:bucket] => :environment do |task, args|
    Redis::List.new('visited').clear
    Recorder::Retreader.perform_async args.bucket
  end

  desc "Run the crawler in Recrod::Rescreener mode"
  task :rescreener, [:bucket] => :environment do |task, args|
    Redis::List.new('visited').clear
    Recorder::Rescreener.perform_async args.bucket
  end
end
