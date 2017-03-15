class Crawler::ScraperOne < Crawler::Sampler
  sidekiq_options queue: :scraper_one,
                  retry: true,
                  backtrace: true,
                  unique: :until_and_while_executing,
                  unique_expiration: 120 * 60

  def next_type
    @type ||= 'ScrimperOne'
  end

  def paginate
    parser.paginate.each do |next_url|
      Crawler::ScraperOne.perform_async next_url
    end
  end
end
