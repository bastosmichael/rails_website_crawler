class Crawler::ScraperEight < Crawler::Scraper
  sidekiq_options queue: :scraper_eight,
                  retry: true,
                  backtrace: true,
                  unique: :until_and_while_executing,
                  unique_expiration: 120 * 60

  def next_type
    @type ||= 'ScrimperEight'
  end

  def paginate
    parser.paginate.each do |next_url|
      Crawler::ScraperEight.perform_async next_url
    end
  end
end
