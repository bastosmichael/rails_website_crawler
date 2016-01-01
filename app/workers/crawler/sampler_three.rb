class Crawler::SamplerThree < Crawler::Sampler
  sidekiq_options queue: :sampler_three,
                  retry: true,
                  backtrace: true,
                  unique: :until_executed

  def perform(url, type = 'ScrimperThree')
    return if url.nil?
    @url = url
    @type = type
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
    Crawler::Sampler.perform_async @url
  rescue Mechanize::RedirectLimitReachedError => e
    nil
  end
end
