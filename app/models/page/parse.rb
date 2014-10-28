class Page::Parse < Page::Base
  include PageHelper
  include OpenGraphHelper
  include SchemaOrgHelper

  def build
    parent_build
    self.methods.grep(/find_/).each { |parse| self.send(parse) } if @type
  end

  def parent_build
    build_open_graph
    build_schema
    build_page
  end

  def screenshot
    @screenshot ||= File.join(@id, date) + '.jpg'
  end

  def remove_extras symbol
    remove_instance_variable(symbol) rescue nil
  end

  def save
    remove_instance_variable(:@page)
    remove_instance_variable(:@links) if @links
    remove_instance_variable(:@internal_links) if @internal_links
    remove_instance_variable(:@external_links) if @external_links
    remove_instance_variable(:@uri) rescue nil
    hash = {}
    instance_variables.each do |var|
      value = instance_variable_get(var)
      hash[var.to_s.delete("@")] = value if !value.blank?
    end
    hash
  end

  def links
    @links ||= page.links.map do |link|
      remove_hash_bangs(clean_up_link(link.href))
    end.compact.uniq
  end

  def internal_links
    @internal_links ||= links.map { |link| link if internal? link }.compact
  end

  def external_links
    @external_links ||= links.map { |link| link if !internal? link }.compact
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
