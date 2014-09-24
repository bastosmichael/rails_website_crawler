class Sitemap < Url
  attr_accessor :xml

  def parser
    xml.xml
  end

  def index_links
    @index_links ||= parser.css('//sitemap/loc').map { |u| u.text }.compact.uniq.sort
  end

  def site_links
    @site_links ||= parser.css('//url/loc').map { |u| u.text }.compact.uniq.sort
  end

  def base
    "#{uri.scheme}://#{uri.host}"
  end

  def indexes?
    index_links.any?
  end

  def sites?
    index_links.any?
  end
end
