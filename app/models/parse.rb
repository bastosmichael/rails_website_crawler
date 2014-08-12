class Parse < Url
  URI_REGEX = /\A#{URI::regexp(['http', 'https'])}\z/

  attr_accessor :page

  def links
    page.links.map do |link| 
      clean_up_link(link.href)
    end.compact
  end

  def internal_links
    links.map { |link| link if internal? link }.compact
  end

  def external_links
    links.map { |link| link if !internal? link }.compact
  end

  def clean_up_link link
    link_uri = URI.parse(link)
    if link_uri.scheme.nil? && link_uri.host.nil?
      link = (base + link)
    else 
      link
    end
  rescue
    nil
  end

  def base
    "#{page.uri.scheme}://#{page.uri.host}"
  end

  def internal? link
    URI.parse(link).host == host
  end

end