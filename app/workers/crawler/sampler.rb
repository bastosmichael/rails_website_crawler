class Crawler::Sampler < Crawler::Base
  sidekiq_options queue: :sampler,
                  retry: true,
                  backtrace: true,
                  unique: :until_and_while_executing,
                  unique_expiration: 120 * 60

  def perform(url, type = nil)
    return if url.nil?

    if type.nil?
      next_type
    else
      @type = type
    end

    @url = url
    parser.page = scraper.get
    internal_links
    upload
    visit.cache unless internal_links.empty?
  rescue Mechanize::ResponseCodeError => e
    if e.response_code == '404' ||
         e.response_code == '410' ||
         e.response_code == '520' ||
         e.response_code == '500' ||
         e.response_code == '301' ||
         e.response_code == '302'
      Recorder::UrlDeleter.perform_async url
    else
      raise
    end
  rescue Mechanize::RedirectLimitReachedError => e
    nil
  end

  def next_type
    @type ||= 'Scrimper'
  end

  def visit
    @visit ||= Page::Visit.new(internal_links, @type)
  end
end
