class Crawl::Sitemap < Page::Url
  attr_accessor :xml

  def parser
    @parser ||= Nokogiri::XML.parse(xml.body)
  end

  def index_links
    @index_links ||= parser.css('//sitemap/loc').map(&:text).compact.uniq.shuffle
  end

  def site_links
    @site_links ||= parser.css('//url/loc').map(&:text).compact.uniq.shuffle
  end

  def base
    "#{uri.scheme}://#{uri.host}"
  end

  def indexes?
    !index_links.empty?
  end

  def sites?
    !site_links.empty?
  end
end
