class Crawler::SitemapperTwo < Crawler::Sitemapper
  sidekiq_options queue: :sitemapper_two,
                  retry: true,
                  backtrace: true,
                  unique: true,
                  unique_job_expiration: 24 * 60

  def perform(url, type = 'ScrimperTwo')
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

  rescue Net::HTTP::Persistent::Error
    Crawler::SitemapperTwo.perform_async @url, @type
  end

  def get_sitemap(url)
    Crawler::SitemapperTwo.perform_async url, @type
  end
end
