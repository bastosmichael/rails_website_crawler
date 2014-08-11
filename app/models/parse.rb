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
  	page.links.select { |link| link if is_uri? link.href }
  end

  def internal_links
    links.map { |link| base + link.href if !has_host? link.href }.compact
  end

  def external_links
    links.map { |link| link.href if has_host? link.href }.compact
  end

  private

  def has_host? link
    is_uri?(link).host
  rescue
    nil
  end

  def is_uri? link
    URI.parse(link)
  rescue URI::InvalidURIError
    nil
  end
end