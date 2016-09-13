# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://" + ENV['DOMAIN'] + '/'

SitemapGenerator::Sitemap.sitemaps_path = "#{ENV['CONTAINER']}/"

SitemapGenerator::Sitemap.create_index = true

SitemapGenerator::Sitemap.sitemaps_host = "http://#{ENV['DOMAIN']}/"

SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(Rails.configuration.config[:fog].merge(fog_directory: "#{ENV['DOMAIN']}-sitemaps",
                                         fog_region: 'us-west-1', fog_provider: 'AWS'))

SitemapGenerator::Sitemap.create do
  # ['boxed-offers'].each do |container|
  begin
    Cloud.new(ENV['CONTAINER']).files.each do |file|
      add (ENV['CONTAINER'] + '/' + file.key.gsub('.json',''))#, lastmod: file.last_modified
    end
  rescue => e
    ap e.message
  end
  # Example. DOMAIN=pricenometry.com CONTAINER=newegg-offers bundle exec rake sitemap:refresh
end
