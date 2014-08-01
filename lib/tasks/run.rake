namespace :run do
  desc "Run the crawler"
  task :url, [:url] => :environment do |task, args|
  	Crawl.instance.process(args.url)
  end
end