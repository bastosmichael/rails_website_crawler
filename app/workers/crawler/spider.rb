class Crawler::Spider < Crawler::Base
  sidekiq_options queue: :spider,
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
    if e.response_code == '404'
      Recorder::UrlDeleter.perform_async url
    else
      raise
    end
  rescue Net::HTTP::Persistent::Error => e
    Crawler::Spider.perform_async @url
  rescue Mechanize::RedirectLimitReachedError => e
    nil
  end
end
