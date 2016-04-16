class Crawl::Social < Page::Url
  require 'social_shares'

  def shares
    all.merge(facebook).delete_if { |_k, v| v == 0 }
  end

  def all
    @all ||= SocialShares.all(url).delete_if { |_k, v| v == 0 }.map { |k, v| { k.to_s + '_shares' => v.to_i } }.reduce({}, :merge)
  end

  def total
    all.values.sum
  end

  def has_shares?
    SocialShares.has_any?(url)
  end

  def facebook
    @facebook ||= sanitize_facebook JSON.parse(Crawl::Base.new("http://graph.facebook.com/?id=#{@url}").get.try(:body), quirks_mode: true)
  rescue
    {}
  end

  def sanitize_facebook(data)
    return nil if data['error_message'] || data['error_type'] || data['error_code']
    return nil if data.empty?
    Flattener.new(data).flatten.delete_if { |_k, v| v == 0 || v == @url }.map { |k, v| { 'facebook_' + k.to_s => v.try(:squish) || v } }.reduce({}, :merge)
  end
end
