class Crawler::ScraperTwo < Crawler::Sampler
  sidekiq_options queue: :scraper_two,
                  retry: true,
                  backtrace: true,
                  unique: :until_and_while_executing,
                  unique_expiration: 120 * 60

  def next_type
    @type ||= 'ScrimperTwo'
  end

  def paginate
    parser.paginate.each do |next_url|
      Crawler::ScraperTwo.perform_async next_url
    end
  end
end
