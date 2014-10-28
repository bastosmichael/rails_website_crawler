class Crawler::Screener < Crawler::Base
  sidekiq_options queue: :screener,
                  retry: true,
                  backtrace: true,
                  unique: true,
                  unique_job_expiration: 24 * 60 * 60

  def perform url, path
    @url = url
    capturer.relative_path = path
    capturer.screen
  end

  def capturer
    @capturer ||= Crawl::Capture.new(@url)
  end
end
