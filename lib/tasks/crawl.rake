namespace :crawl do
  desc "Run the crawler in Crawl::Spider mode"
  task :spider, [:url] => :environment do |task, args|
    Redis::List.new('visited').clear
  	Crawl::Spider.perform_async args.url
  end

  desc "Run the crawler in Crawl::Scrimper mode"
  task :scrimper, [:url] => :environment do |task, args|
  	Crawl::Scrimper.perform_async args.url
  end

  desc "Run the crawler in Crawl::Sampler mode"
  task :sampler, [:url] => :environment do |task, args|
    Redis::List.new('visited').clear
    Crawl::Sampler.perform_async args.url
  end

  desc "Run the crawler in Crawl::Sitemapper mode"
  task :sitemapper, [:url] => :environment do |task, args|
    Crawl::Sitemapper.perform_async args.url
  end
end
