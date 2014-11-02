namespace :record do
  desc "Run the crawler in Recrod::Mover mode"
  task :mover, [:from_bucket, :to_bucket] => :environment do |task, args|
    Redis::List.new('visited').clear
    Recorder::Mover.perform_async args.from_bucket, args.to_bucket
  end

  desc "Run the crawler in Recrod::Rescreener mode"
  task :rescreener, [:bucket] => :environment do |task, args|
    Redis::List.new('visited').clear
    Recorder::Rescreener.perform_async args.bucket
  end


  desc "Run the crawler in Recrod::Rescrimper mode"
  task :rescrimper, [:bucket] => :environment do |task, args|
    Redis::List.new('visited').clear
    Recorder::Rescrimper.perform_async args.bucket
  end


  desc "Run the crawler in Recrod::Resampler mode"
  task :resampler, [:bucket] => :environment do |task, args|
    Redis::List.new('visited').clear
    Recorder::Resampler.perform_async args.bucket
  end


  desc "Run the crawler in Recrod::Respider mode"
  task :respider, [:bucket] => :environment do |task, args|
    Redis::List.new('visited').clear
    Recorder::Respider.perform_async args.bucket
  end
end
