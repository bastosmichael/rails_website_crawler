class Crawler::ScraperFive < Crawler::Scraper
  sidekiq_options queue: :scraper_five,
                  retry: true,
                  backtrace: true,
                  unique: :until_and_while_executing,
                  unique_expiration: 120 * 60

  def next_type
    @type ||= 'ScrimperFive'
  end

  def paginate
    parser.paginate.each do |next_url|
      Crawler::ScraperFive.perform_async next_url
    end
  end
end
