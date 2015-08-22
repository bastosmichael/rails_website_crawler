class Crawler::SpiderOne < Crawler::Spider
  sidekiq_options queue: :spider_one,
                  retry: true,
                  backtrace: true,
                  unique: true,
                  unique_job_expiration: 24 * 60 * 60

  def perform(url)
    @url = url
    parser.page = scraper.get
    internal_links
    upload
    visit.cache
  rescue Mechanize::ResponseCodeError => e
    if e.response_code == '404'
      Recorder::Deleter.perform_async url
    else
      raise
    end
  rescue Net::HTTP::Persistent::Error => e
    Crawler::SpiderOne.perform_async @url
  rescue Mechanize::RedirectLimitReachedError => e
    nil
  end
end
