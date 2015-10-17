class Crawler::Slider < Crawler::Base
  sidekiq_options queue: :slider,
                  retry: true,
                  backtrace: true,
                  unique: :until_executed,
                  unique_job_expiration: 24 * 60 * 60

  def perform(url)
    @url = url
    parser.page = scraper.get
    upload
  rescue Mechanize::ResponseCodeError => e
    if e.response_code == '404' || e.response_code == '520' || e.response_code == '500'
      Recorder::UrlDeleter.perform_async url
    else
      raise
    end
  rescue Net::HTTP::Persistent::Error => e
    Crawler::Slider.perform_async @url
  rescue Mechanize::RedirectLimitReachedError => e
    nil
  end
end
