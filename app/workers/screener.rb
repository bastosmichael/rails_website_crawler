class Screener < Worker
  sidekiq_options queue: :uploader,
                  retry: true,
                  backtrace: true,
                  unique: true,
                  unique_job_expiration: 24 * 60 * 60

  def perform url
    @url = url
    capturer.screen
  end

  def capturer
  	@capturer ||= Capture.new(@url)
  end
end