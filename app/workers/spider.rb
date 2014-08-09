class Spider < Worker
  sidekiq_options :queue => :spider, :backtrace => true, :retry => true

  def perform url, params = nil, headers = ''
  	@url = url
    get_page params, headers
  end

  def get_page params, headers
    params ? scraper.post(params, headers) : scraper.get
  end

  def scraper
  	@scraper ||= Scrape.new(@url)
  end

  def capturer
    @capturer ||= Capture.new(@url)
  end

  def parser
  	@parser ||= Parse.new(scraper.page)
  end
end