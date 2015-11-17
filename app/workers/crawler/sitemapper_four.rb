class Crawler::SitemapperFour < Crawler::Sitemapper
  sidekiq_options queue: :sitemapper_four,
                  retry: true,
                  backtrace: true,
                  unique: :until_executed

  def perform(url, type = 'ScrimperFour')
    if Sidekiq::Queue.new(type.underscore).size <= 50_000
      @url = url
      @type = type
      @name = Page::Url.new(url).name
      @container = Rails.configuration.config[:admin][:api_containers].find { |c| c.include?(@name) }
      @index = Rails.env + '-' + @container

      get_xml

      sitemap.site_links.with_progress("Processing Urls from #{url}").each do |u|
        check_page(u)
      end if sitemap.sites?

      sitemap.index_links.with_progress("Processing Sitemaps from #{url}").each do |u|
        get_sitemap u
      end if sitemap.indexes?
    else
      Crawler::SitemapperFour.perform_async url, type
    end
  rescue Net::HTTP::Persistent::Error
    Crawler::SitemapperFour.perform_async @url, @type
  end

  def get_sitemap(url)
    Crawler::SitemapperFour.perform_async url, @type
  end
end
