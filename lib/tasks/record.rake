namespace :record do
  desc "Run the crawler in Recrod::Retreader mode"
  task :retreader, [:bucket] => :environment do |task, args|
    Record::Retreader.perform_async args.bucket
  end
end
