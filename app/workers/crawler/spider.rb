class Crawler::Spider < Crawler::Base
  sidekiq_options queue: :spider,
                  retry: true,
                  backtrace: true,
                  unique: :until_and_while_executing,
                  unique_expiration: 120 * 60

  def perform(url)
    return if url.nil?
    @url = url
    parser.page = scraper.get
    internal_links
    upload
    visit.cache unless internal_links.empty?
  rescue Mechanize::ResponseCodeError => e
    if e.response_code == '404' ||
         e.response_code == '520' ||
         e.response_code == '500' ||
         e.response_code == '301'
      Recorder::UrlDeleter.perform_async url
    else
      raise
    end
  rescue Mechanize::RedirectLimitReachedError => e
    nil
  end
end
