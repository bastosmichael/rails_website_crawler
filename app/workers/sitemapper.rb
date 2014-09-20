class SiteMapper < Creeper
  sidekiq_options queue: :sitemapper,
                  retry: true,
                  backtrace: true,
                  unique: true,
                  unique_job_expiration: 24 * 60 * 60

  def perform url
    @url = url
    if sitemapper.final_sitemap?
      get_xml
      sitemapper.site_links.each { |u| get_page u }
    else
      get_xml
      sitemapper.index_links.each { |u| get_sitemap u }
    end
  rescue Net::HTTP::Persistent::Error
    SiteMapper.perform_async @url
  end

  def get_xml
    sitemapper.xml = scraper.get
  end

  def get_page url
    Scrimper.perform_async url
  end

  def get_sitemap url
    Sitemapper.perform_async url
  end

  def sitemapper
    @sitemapper ||= Sitemap.new(@url)
  end
end
