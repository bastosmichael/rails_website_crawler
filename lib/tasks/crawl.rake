namespace :crawl do
  desc 'Run the crawler in Crawler::Spider mode'
  task :spider, [:url] => :environment do |_task, args|
    Redis::List.new('visited').clear
    Crawler::Spider.perform_async args.url
  end

  desc 'Run the crawler in Crawler::Scrimper mode'
  task :scrimper, [:url] => :environment do |_task, args|
    Redis::List.new('visited').clear
    Crawler::Scrimper.perform_async args.url
  end

  desc 'Run the crawler in Crawler::Sampler mode'
  task :sampler, [:url] => :environment do |_task, args|
    Redis::List.new('visited').clear
    Crawler::Sampler.perform_async args.url
  end

  desc 'Run the crawler in Crawler::Sitemapper mode'
  task :sitemapper, [:url] => :environment do |_task, args|
    Redis::List.new('visited').clear
    Crawler::Sitemapper.perform_async args.url
  end
end
