class Crawl::Social < Page::Url
  require 'social_shares'

  def shares
    all.merge({'total_shares' => total})
  end

  def all
    @all ||= SocialShares.all(url).delete_if { |k, v| v == 0 }.map { |k, v| { k.to_s + '_shares' => v.to_i } }.reduce({}, :merge)
  end

  def total
    all.values.sum
  end

  def has_shares?
    SocialShares.has_any?(url)
  end
end
