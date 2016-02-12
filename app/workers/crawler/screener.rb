class Crawler::Screener < Crawler::Base
  sidekiq_options queue: :screener,
                  retry: true,
                  backtrace: true,
                  unique: :until_and_while_executing,
                  unique_expiration: 120 * 60

  def perform(url, path)
    return if url.nil?
    @url = url
    capturer.relative_path = path
    capturer.screen
  rescue EOFError => e
    Crawler::Screener.perform_async url, path
  rescue Net::ReadTimeout => e
    Crawler::Screener.perform_async url, path
  rescue ChildProcess::TimeoutError => e
    Crawler::Screener.perform_async url, path
  rescue Selenium::WebDriver::Error::WebDriverError => e
    Crawler::Screener.perform_async url, path
  end

  def capturer
    @capturer ||= Crawl::Capture.new(@url)
  end
end
