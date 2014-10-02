class Spider < Creeper
  sidekiq_options queue: :spider,
                  retry: true,
                  backtrace: true,
                  unique: true,
                  unique_job_expiration: 24 * 60 * 60

  def perform url, params = nil, headers = ''
    @url = url
    @params = params
    @headers = headers
    get_links params, headers
    scrimp_page
    visit
  rescue Net::HTTP::Persistent::Error
    Spider.perform_async @url, @params, @headers
  end

  def get_links params = nil, headers = ''
    parser.page = params ? scraper.post(params, headers) : scraper.get
  end

  def scrimp_page
    Scrimper.perform_async @url, @params, @headers
  end

  def visit
    @visit ||= Visit.new(parser.internal_links)
  end
end
