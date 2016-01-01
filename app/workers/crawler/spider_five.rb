class Crawler::SpiderFive < Crawler::Spider
  sidekiq_options queue: :spider_five,
                  retry: true,
                  backtrace: true,
                  unique: :until_executed

  def perform(url)
    return if url.nil?
    @url = url
    parser.page = scraper.get
    internal_links
    upload
    visit.cache
  rescue Mechanize::ResponseCodeError => e
    if e.response_code == '404' ||
         e.response_code == '520' ||
         e.response_code == '500' ||
         e.response_code == '503'
      Recorder::UrlDeleter.perform_async url
    else
      raise
    end
  rescue Net::HTTP::Persistent::Error => e
    Crawler::SpiderFive.perform_async @url
  rescue Mechanize::RedirectLimitReachedError => e
    nil
  end
end
