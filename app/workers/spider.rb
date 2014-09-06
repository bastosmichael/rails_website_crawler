class Spider < Creeper
  sidekiq_options queue: :spider, backtrace: true, unique: true, unique_job_expiration: 24 * 60 * 60

  def perform url, params = nil, headers = ''
    @url = url
    @params = params
    @headers = headers
    get_page params, headers
    visit
  rescue Net::HTTP::Persistent::Error
    Spider.perform_async @url, @params, @headers
  end

  def visit
    @visit ||= Visit.new(parser.internal_links)
  end
end