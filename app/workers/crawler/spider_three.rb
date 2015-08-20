class Crawler::SpiderThree < Crawler::Spider
  sidekiq_options queue: :spider_three,
                  retry: true,
                  backtrace: true,
                  unique: true,
                  unique_job_expiration: 24 * 60 * 60

  def perform(url)
    @url = url
    parser.page = scraper.get
    visit.cache
    upload
  rescue Mechanize::ResponseCodeError => e
    if e.response_code == '404'
      Recorder::Deleter.perform_async url
    else
      raise
    end
  rescue Net::HTTP::Persistent::Error => e
    Crawler::SpiderThree.perform_async @url
  rescue Mechanize::RedirectLimitReachedError => e
    nil
  end
end
