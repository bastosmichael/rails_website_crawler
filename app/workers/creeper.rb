class Creeper < Worker
  def get_page params = nil, headers = ''
    parser.page = params ? scraper.post(params, headers) : scraper.get
  end

  def scraper
  	@scraper ||= Scrape.new(@url)
  end

  def parser
  	@parser ||= Parse.new(@url)
  end
end