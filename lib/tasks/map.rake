namespace :map do
  desc 'Run the crawler in Mapper::Reader mode'
  task :reader, [:bucket] => :environment do |_task, args|
    Redis::List.new('visited').clear
    Mapper::Reader.perform_async args.bucket
  end
end
