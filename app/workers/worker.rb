class Worker
  include Sidekiq::Worker

  def scraper
    @scraper ||= Scrape.new(@url)
  end
end
