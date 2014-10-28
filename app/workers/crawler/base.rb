class Crawler::Base < Worker
  def parser
    @parser ||= scraper.name.capitalize.constantize.new(@url)
  rescue NameError
    @parser ||= Parse.new(@url)
  end

  def parsed
    @parsed ||= parser.save if parser.build
  end

  def exists?
    parsed.nil? ? false : parsed['type']
  rescue
    false
  end

  def upload
    Recorder::Uploader.perform_async parsed if exists?
  end
end
