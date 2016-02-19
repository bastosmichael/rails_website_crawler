class Crawler::Sitemapper < Crawler::Base
  sidekiq_options queue: :sitemapper,
                  retry: true,
                  backtrace: true,
                  unique: :until_and_while_executing,
                  unique_expiration: 120 * 60

  def perform(url, type = 'Scrimper')
    return if url.nil?
    while Sidekiq::Queue.new(type.underscore).size > 0
      sleep 30
    end

    @url = url
    @type = type
    @name = Page::Url.new(url).name
    @container = Rails.configuration.config[:admin][:api_containers].find { |c| c.include?(@name) }

    get_xml

    sitemap.site_links.each do |u|
      check_page(u)
    end if sitemap.sites?

    sitemap.index_links.each do |u|
      get_sitemap u
    end if sitemap.indexes?
  end

  def get_xml
    sitemap.xml = scraper.get
    scraper.clear
  end

  def check_page(url)
    if new_url = @name.capitalize.constantize.sanitize_url(url)
      get_page(new_url) if Elasticsearch::Model.client.search(index: '_all', type: @container, body: { query: { match_phrase_prefix: { url: new_url } } })['hits']['total'] == 0
    end
  rescue NoMethodError => e
    get_page(url) if Elasticsearch::Model.client.search(index: '_all', type: @container, body: { query: { match_phrase_prefix: { url: url } } })['hits']['total'] == 0
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
