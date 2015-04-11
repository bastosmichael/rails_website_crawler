class Crawler::Screener < Crawler::Base
  sidekiq_options queue: :screener,
                  retry: true,
                  backtrace: true

  def perform(url, path)
    @url = url
    capturer.relative_path = path
    capturer.screen
  rescue ChildProcess::TimeoutError => e
    Crawler::Screener.perform_async url, path
  rescue Selenium::WebDriver::Error::WebDriverError => e
    Crawler::Screener.perform_async url, path
  end

  def capturer
    @capturer ||= Crawl::Capture.new(@url)
  end
end
