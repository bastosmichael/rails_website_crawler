class Crawler::Base < Worker
  def scraper
    @scraper ||= Crawl::Base.new(@url)
  end

  def parser
    @parser ||= scraper.name.capitalize.constantize.new(@url)
  rescue NameError
    @parser ||= Page::Parse.new(@url)
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

  def social
    @social ||= Crawl::Social.new(@url)
  rescue
    {}
  end
end
