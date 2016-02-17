class Crawler::SitemapperFive < Crawler::Sitemapper
  sidekiq_options queue: :sitemapper_five,
                  retry: true,
                  backtrace: true,
                  unique: :until_and_while_executing,
                  unique_expiration: 120 * 60

  def perform(url, type = 'ScrimperFive')
    return if url.nil?
    if Sidekiq::Queue.new(type.underscore).size <= 0
      @url = url
      @type = type
      @name = Page::Url.new(url).name
      @container = Rails.configuration.config[:admin][:api_containers].find { |c| c.include?(@name) }
      @index = Rails.env + '-' + @container

      get_xml

      sitemap.site_links.each do |u|
        check_page(u)
      end if sitemap.sites?

      sitemap.index_links.each do |u|
        get_sitemap u
      end if sitemap.indexes?
    else
      raise "#{type} queue still too large"
    end
  rescue Net::HTTP::Persistent::Error
    Crawler::SitemapperFive.perform_async @url, @type
  end

  def get_sitemap(url)
    Crawler::SitemapperFive.perform_async url, @type
  end
end
