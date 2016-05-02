class Crawler::SitemapperNine < Crawler::Sitemapper
  sidekiq_options queue: :sitemapper_nine,
                  retry: true,
                  backtrace: true,
                  unique: :until_and_while_executing,
                  unique_expiration: 120 * 60

  def perform(url, type = 'ScrimperNine')
    return if url.nil?
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

  def get_sitemap(url)
    Crawler::SitemapperNine.perform_async url, @type
  end
end
