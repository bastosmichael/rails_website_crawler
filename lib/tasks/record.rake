namespace :record do
  desc "Run the crawler in Recrod::Mover mode"
  task :mover, [:from_bucket, :to_bucket] => :environment do |task, args|
    Redis::List.new('visited').clear
    Recorder::Mover.perform_async args.from_bucket, args.to_bucket
  end

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
