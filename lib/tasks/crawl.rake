namespace :crawl do
  desc "Run the crawler in Crawler::Spider mode"
  task :spider, [:url] => :environment do |task, args|
    Redis::List.new('visited').clear
  	Crawler::Spider.perform_async args.url
  end

  desc "Run the crawler in Crawler::Scrimper mode"
  task :scrimper, [:url] => :environment do |task, args|
  	Crawler::Scrimper.perform_async args.url
  end

  desc "Run the crawler in Crawler::Sampler mode"
  task :sampler, [:url] => :environment do |task, args|
    Redis::List.new('visited').clear
    Crawler::Sampler.perform_async args.url
  end

  desc "Run the crawler in Crawler::Sitemapper mode"
  task :sitemapper, [:url] => :environment do |task, args|
    Crawler::Sitemapper.perform_async args.url
  end
end
