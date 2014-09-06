class Scrimper < Creeper
  sidekiq_options queue: :scrimper, backtrace: true, unique: true, unique_job_expiration: 24 * 60 * 60

  def perform url, params = nil, headers = ''
    @url = url
    @params = params
    @headers = headers
    get_page params, headers
  rescue Net::HTTP::Persistent::Error
    Spider.perform_async @url, @params, @headers
  end
end