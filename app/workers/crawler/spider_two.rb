class Crawler::SpiderTwo < Crawler::Spider
  sidekiq_options queue: :spider_two,
                  retry: true,
                  backtrace: true,
                  unique: :until_executed

  def perform(url)
    @url = url
    parser.page = scraper.get
    visit.cache
    upload
  rescue Mechanize::ResponseCodeError => e
    if e.response_code == '404'
      Recorder::UrlDeleter.perform_async url
    else
      raise
    end
  rescue Net::HTTP::Persistent::Error => e
    Crawler::SpiderTwo.perform_async @url
  rescue Mechanize::RedirectLimitReachedError => e
    nil
  end
end
