class Crawler::ScraperSix < Crawler::Sampler
  sidekiq_options queue: :scraper_six,
                  retry: true,
                  backtrace: true,
                  unique: :until_and_while_executing,
                  unique_expiration: 120 * 60

  def next_type
    @type ||= 'ScrimperSix'
  end

  def paginate
    parser.paginate.each do |next_url|
      Crawler::ScraperSix.perform_async next_url
    end
  end
end
