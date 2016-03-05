class Crawler::Sampler < Crawler::Base
  TYPE = 'Scrimper'

  sidekiq_options queue: :sampler,
                  retry: true,
                  backtrace: true,
                  unique: :until_and_while_executing,
                  unique_expiration: 120 * 60

  def perform(url, type = TYPE)
    return if url.nil?
    @url = url
    @type = type
    parser.page = scraper.get
    visit.cache unless internal_links.empty?
    upload
  rescue Mechanize::ResponseCodeError => e
    if e.response_code == '404' ||
         e.response_code == '520' ||
         e.response_code == '500'
      Recorder::UrlDeleter.perform_async url
    else
      raise
    end
  rescue Net::HTTP::Persistent::Error => e
    self.class.name.constantize.perform_async @url
  rescue Mechanize::RedirectLimitReachedError => e
    nil
  end

  def visit
    @visit ||= Page::Visit.new(internal_links, @type)
  end
end
