# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://" + ENV['DOMAIN'] + '/'

SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create_index = true

SitemapGenerator::Sitemap.sitemaps_host = "http://#{ENV['DOMAIN']}-sitemaps.s3.amazonaws.com/"

SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(Rails.configuration.config[:fog].merge(fog_directory: "#{ENV['DOMAIN']}-sitemaps",
                                         fog_region: 'us-west-1', fog_provider: 'AWS'))

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
  # ['boxed-offers'].each do |container|
  Rails.configuration.config[:admin][:api_containers].reverse.each do |container|
    begin
      Cloud.new(container).files.each do |file|
        add (container + '/' + file.key.gsub('.json','')), lastmod: file.last_modified
      end
    rescue => e
      ap e.message
    end
  end
end
