class Links < Page
  def all
    @all ||= page.links.map do |link|
      remove_hash_bangs(clean_up_link(link.href))
    end.compact.uniq
  end

  def internal
    @internal ||= all.map { |link| link if internal? link }.compact
  end

  def external
    @external ||= all.map { |link| link if !internal? link }.compact
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

  def remove_hash_bangs link
    return if link.nil?
    if hash_bang = link.match(/(.+?)\#/)
      hash_bang[1]
    else
      link
    end
  end

  def internal? link
    get_host_without_www(URI.parse(link)) == host
  rescue
    nil
  end
end
