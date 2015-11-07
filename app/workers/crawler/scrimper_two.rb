class Crawler::ScrimperTwo < Crawler::Base
  sidekiq_options queue: :scrimper_two,
                  retry: true,
                  backtrace: true,
                  unique: :until_executed

  def perform(url)
    @url = url
    parser.page = scraper.get
    upload
  rescue Mechanize::ResponseCodeError => e
    if e.response_code == '404'
      Recorder::UrlDeleter.perform_async url
    else
      raise
    end
  rescue Net::HTTP::Persistent::Error => e
    Crawler::ScrimperTwo.perform_async @url
  rescue Mechanize::RedirectLimitReachedError => e
    nil
  end
end
