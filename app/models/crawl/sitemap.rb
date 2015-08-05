class Crawl::Sitemap < Page::Url
  attr_accessor :xml

  def parser
    @parser ||= begin
      if uri.to_s.ends_with?('.gz')
        require 'zlib'
        require 'stringio'
        gz = Zlib::GzipReader.new(StringIO.new(xml.body.to_s))
        Nokogiri::XML.parse(gz.read)
      else
        Nokogiri::XML.parse(xml.body)
      end
    rescue Zlib::GzipFile::Error
      Nokogiri::XML.parse(xml.body)
    end
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
