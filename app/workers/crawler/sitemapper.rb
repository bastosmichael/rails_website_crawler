class Crawler::Sitemapper < Crawler::Base
  sidekiq_options queue: :sitemapper,
                  retry: true,
                  backtrace: true,
                  unique: true,
                  unique_job_expiration: 24 * 60

  def perform(url, type = 'Scrimper')
    @url = url
    @type = type
    @name = Page::Url.new(url).name
    @container = Rails.configuration.config[:admin][:api_containers].select {|c| c.include?(@name) }.first

    get_xml

    sitemap.site_links.with_progress.each do |u|
      check_page(u)
    end if sitemap.sites?

    sitemap.index_links.with_progress.each do |u|
      get_sitemap u
    end if sitemap.indexes?

  rescue Net::HTTP::Persistent::Error
    Crawler::Sitemapper.perform_async @url, @type
  end

  def get_xml
    sitemap.xml = scraper.get
  end

  def check_page(url)
    id = @name.capitalize.constantize.find_id url
    get_page(url) unless Elasticsearch::Model.client.indices.exists index: @container, type: id
  rescue NoMethodError => e
    get_page(url)
  end

  def get_page(url)
    ('Crawler::' + @type).constantize.perform_async url
  end

  def get_sitemap(url)
    Crawler::Sitemapper.perform_async url, @type
  end

  def sitemap
    @sitemap ||= Crawl::Sitemap.new(@url)
  end
end
