class Crawl
  include Singleton

  def process_url url
  	Spider.perform_async url
  end

  def process_urls urls
  	ap urls
  end
end