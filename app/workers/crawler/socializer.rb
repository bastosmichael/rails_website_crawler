class Crawler::Socializer < Crawler::Base
  sidekiq_options queue: :socializer,
                  retry: true,
                  backtrace: true,
                  unique: :until_and_while_executing,
                  unique_expiration: 120 * 60

  def perform(url)
    return if url.nil?
    @url = url
    parser.page = scraper.get
    upload
  rescue Mechanize::ResponseCodeError => e
    if e.response_code == '404' ||
         e.response_code == '410' ||
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

  def upload
    parsed = parser.save if parser.build
    if parsed && parsed['type']
      Recorder::Uploader.perform_async parsed.merge(social.shares)
    end
  end
end
