class Crawl
  include Singleton

  def scrimp_url url
    Scrimper.perform_async url
  end

  def spider_url url
  	clear_visited
  	Spider.perform_async url
  end

  def scrimp_urls urls
    ap urls
  end

  def clear_visited
  	Redis::List.new('visited').clear
  end
end