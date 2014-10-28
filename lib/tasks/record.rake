namespace :record do
  desc "Run the crawler in Recrod::Retreader mode"
  task :retreader, [:bucket] => :environment do |task, args|
    Recorder::Retreader.perform_async args.bucket
  end
end
