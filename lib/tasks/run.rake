namespace :run do
  desc "Run the crawler"
  task :url, [:url] => :environment do |task, args|
  	Crawl.instance.process_url(args.url)
  end

  desc "Run the crawlers"
  task :urls, 1000.times.map { |i| "arg#{i}".to_sym } => :environment do |t, args|
  	Crawl.instance.process_urls(args.values)
  end
end