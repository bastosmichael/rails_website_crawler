# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://" + ENV['DOMAIN'] + '/'

SitemapGenerator::Sitemap.sitemaps_path = "#{ENV['CONTAINER']}/"

SitemapGenerator::Sitemap.create_index = true

SitemapGenerator::Sitemap.public_path = "tmp/#{ENV['DOMAIN']}/#{ENV['CONTAINER']}/"

SitemapGenerator::Sitemap.sitemaps_host = "https://#{ENV['DOMAIN']}/"

SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(Rails.configuration.config[:fog].merge(fog_directory: "#{ENV['DOMAIN']}-sitemaps",
                                         fog_region: 'us-west-1', fog_provider: 'AWS'))
sitemap_default_options = {
  changefreq: nil,
  priority: nil,
  lastmod: nil
}

SitemapGenerator::Sitemap.create do
  # ['boxed-offers'].each do |container|
  begin
    Cloud.new(ENV['CONTAINER']).files.each do |file|
      add (ENV['CONTAINER'] + '/' + file.key.gsub('.json','')), sitemap_default_options#.merge(lastmod: file.last_modified)
    end
  rescue => e
    ap e.message
  end
  # Example. DOMAIN=pricenometry.com CONTAINER=newegg-offers bundle exec rake sitemap:refresh
end
