class Sitemapper < Worker
  sidekiq_options queue: :sitemapper,
                  retry: true,
                  backtrace: true,
                  unique: true,
                  unique_job_expiration: 24 * 60 * 60

  def perform url
    @url = url
    get_xml
    sitemapper.site_links.each { |u| get_page u } if sitemapper.sites?
    sitemapper.index_links.each { |u| get_sitemap u } if sitemapper.indexes?
  rescue Net::HTTP::Persistent::Error
    Sitemapper.perform_async @url
  end

  def get_xml
    sitemapper.xml = scraper.get
  end

  def get_page url
    Sampler.perform_async url
  end

  def get_sitemap url
    Sitemapper.perform_async url
  end

  def sitemapper
    @sitemapper ||= Sitemap.new(@url)
  end
end
