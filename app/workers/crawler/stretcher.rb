class Crawler::Stretcher < Crawler::Base
  sidekiq_options queue: :stretcher,
                  retry: true,
                  backtrace: true,
                  unique: :until_and_while_executing,
                  unique_expiration: 120 * 60

  def perform(url, hash = {})
    return if url.nil?
    @parsed = hash

    @url = url
    parser.page = scraper.get
    upload
  rescue Mechanize::ResponseCodeError => e
    if e.response_code == '404' ||
         e.response_code == '410' ||
         e.response_code == '520' ||
         e.response_code == '500' ||
         e.response_code == '301' ||
         e.response_code == '302'
      Recorder::UrlAvailability.perform_async url
    else
      raise
    end
  rescue Mechanize::RedirectLimitReachedError => e
    nil
  end
end
