class Crawler::Sampler < Crawler::Base
  sidekiq_options queue: :sampler,
                  retry: true,
                  backtrace: true,
                  unique: :until_executed,
                  unique_job_expiration: 24 * 60 * 60

  def perform(url, type = 'Scrimper')
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

  def visit
    @visit ||= Page::Visit.new(internal_links, @type)
  end
end
