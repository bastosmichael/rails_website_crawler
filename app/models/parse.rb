class Parse
  def initialize page
  	@page = page
  end

  def base
    "#{page.uri.scheme}://#{page.uri.host}"
  end

  def page
    @page
  end

  def links
  	page.links
  end

  def internal_links
    links.map { |link| File.join(base, link) if !has_host? link }.compact
  end

  def external_links
    links.map { |link| link if has_host? }.compact
  end

  private

  def has_host? link
    URI.parse(link.href).host
  end  
end