class Crawl::Screener < Worker
  sidekiq_options queue: :screener,
                  retry: true,
                  backtrace: true,
                  unique: true,
                  unique_job_expiration: 24 * 60 * 60

  def perform url, date = nil
    @url = url
    capturer.date = date
    capturer.screen
  end

  def capturer
    @capturer ||= Capture.new(@url)
  end
end
