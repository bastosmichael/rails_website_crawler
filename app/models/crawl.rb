class Crawl
  include Singleton

  def process_url url
  	clear_visited
  	Spider.perform_async url
  end

  def process_urls urls
  	ap urls
  end

  def clear_visited
  	Redis::List.new('visited').clear
  end
end