namespace :run do
  desc "Run the crawler in spider mode"
  task :spider, [:url] => :environment do |task, args|
    Redis::List.new('visited').clear
  	Spider.perform_async args.url
  end

  desc "Run the crawler in scrimper mode"
  task :scrimper, [:url] => :environment do |task, args|
  	Scrimper.perform_async args.url
  end

  desc "Run the crawler in sitemapper mode"
  task :sitemapper, [:url] => :environment do |task, args|
    Sitemapper.perform_async args.url
  end

  desc "Run the crawler in sampler mode"
  task :sampler, [:url] => :environment do |task, args|
    Sampler.perform_async args.url
  end

  desc "Run the crawlers"
  task :scrimpers, 1000.times.map { |i| "arg#{i}".to_sym } => :environment do |t, args|
  	Crawl.instance.scrimper_urls(args.values)
  end
end
