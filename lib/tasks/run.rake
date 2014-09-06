namespace :run do
  desc "Run the crawler in spider mode"
  task :spider, [:url] => :environment do |task, args|
  	Crawl.instance.spider_url(args.url)
  end

  desc "Run the crawler in scrimper mode"
  task :scrimper, [:url] => :environment do |task, args|
  	Crawl.instance.scrimp_url(args.url)
  end

  desc "Run the crawlers"
  task :scrimpers, 1000.times.map { |i| "arg#{i}".to_sym } => :environment do |t, args|
  	Crawl.instance.scrimper_urls(args.values)
  end
end