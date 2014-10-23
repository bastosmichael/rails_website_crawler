class Crawl::Sitemapper < Worker
  sidekiq_options queue: :sitemapper,
                  retry: true,
                  backtrace: true,
                  unique: true,
                  unique_job_expiration: 24 * 60 * 60

  def perform url
    @url = url
    get_xml
    sitemap.site_links.each { |u| get_page u } if sitemap.sites?
    sitemap.index_links.each { |u| get_sitemap u } if sitemap.indexes?
  rescue Net::HTTP::Persistent::Error
    Crawl::Sitemapper.perform_async @url
  end

  def get_xml
    sitemap.xml = scraper.get
  end

  def get_page url
    Crawl::Sampler.perform_async url
  end

  def get_sitemap url
    Crawl::Sitemapper.perform_async url
  end

  def sitemap
    @sitemap ||= Sitemap.new(@url)
  end
end