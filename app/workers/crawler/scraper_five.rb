class Crawler::ScraperFive < Crawler::Sampler
  sidekiq_options queue: :scraper_five,
                  retry: true,
                  backtrace: true,
                  unique: :until_and_while_executing,
                  unique_expiration: 120 * 60

  def next_type
    @type ||= 'ScrimperFive'
  end
end
