class Crawler::Base < Worker
  def scraper
    @scraper ||= Crawl::Base.new(@url)
  end

  def parser
    @parser ||= scraper.name.capitalize.constantize.new(@url)
  rescue NameError
    @parser ||= Page::Parse.new(@url)
  end

  def upload
    scraper.clear
    @parsed = parsed.merge(parser.save) if parser.build
    if parsed.presence && parsed['type']
      Recorder::Uploader.perform_async parsed
    end
  end

  def parsed
    @parsed ||= {}
  end

  def social
    @social ||= Crawl::Social.new(@url)
  rescue
    {}
  end

  def internal_links
    @internal_links ||= begin
      parser.internal_links.map do |url|
        scraper.name.capitalize.constantize.sanitize_url(url)
      end.compact
    rescue
      parser.internal_links
    end
  end

  def visit
    internal_links.each do |link|
      ('Crawler::' + next_type).constantize.perform_async url
    end
  end
end
