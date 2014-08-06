class Spider < Worker
  sidekiq_options :queue => :spider, :backtrace => true, :retry => true

  def perform url, params = nil, headers = nil
  	@url = url

  end

  def scraper
  	@scraper ||= Scrape.new(@url)
  end

  def parser
  	@parser ||= Parse.new(@page)
  end
end