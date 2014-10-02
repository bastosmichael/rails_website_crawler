class Creeper < Worker
  def scraper
  	@scraper ||= Scrape.new(@url)
  end

  def parser
    @parser ||= scraper.name.capitalize.constantize.new(@url)
  rescue NameError
    @parser ||= Parse.new(@url)
  end
end
