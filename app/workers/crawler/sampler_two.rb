class Crawler::SamplerTwo < Crawler::Sampler
  sidekiq_options queue: :sampler_two,
                  retry: true,
                  backtrace: true,
                  unique: :until_executed,
                  unique_job_expiration: 24 * 60 * 60

  def perform(url, type = 'ScrimperTwo')
    @url = url
    @type = type
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
    Crawler::Sampler.perform_async @url
  rescue Mechanize::RedirectLimitReachedError => e
    nil
  end
end
