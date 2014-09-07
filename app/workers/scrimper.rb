class Scrimper < Creeper
  sidekiq_options queue: :scrimper,
                  retry: true,
                  backtrace: true,
                  unique: true,
                  unique_job_expiration: 24 * 60 * 60

  def perform url, params = nil, headers = ''
    @url = url
    @params = params
    @headers = headers
    get_page params, headers
  rescue Net::HTTP::Persistent::Error
    Scrimper.perform_async @url, @params, @headers
  end

  def get_page params = nil, headers = ''
    parser.page = params ? scraper.post(params, headers) : scraper.get
  end

  def parser
    @parser ||= scraper.name.capitalize.constantize.new(@url)
  rescue NameError
  	@parser ||= Parse.new(@url)
  end
end