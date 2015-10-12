class Crawler::ScrimperFive < Crawler::Base
  sidekiq_options queue: :scrimper_five,
                  retry: true,
                  backtrace: true,
                  unique: :until_executed,
                  unique_job_expiration: 24 * 60 * 60

  def perform(url)
    @url = url
    parser.page = scraper.get
    upload
  rescue Mechanize::ResponseCodeError => e
    if e.response_code == '404'
      Recorder::Deleter.perform_async url
    else
      raise
    end
  rescue Net::HTTP::Persistent::Error => e
    Crawler::ScrimperFive.perform_async @url
  rescue Mechanize::RedirectLimitReachedError => e
    nil
  end
end
