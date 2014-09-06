class Creeper < Worker
  def scraper
  	@scraper ||= Scrape.new(@url)
  end
end