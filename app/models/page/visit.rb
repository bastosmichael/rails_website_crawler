class Page::Visit
  def initialize(links)
    @links = *links
  end

  def spider
    @links.each do |link|
      key = Page::Url.new(link).cache_key
      unless keys.include? key
        keys << key
        Crawler::Spider.perform_async link
      end
    end
  end

  def sample
    @links.each do |link|
      key = Page::Url.new(link).cache_key
      unless keys.include? key
        keys << key
        Crawler::Scrimper.perform_async link
      end
    end
  end

  def keys
    @keys ||= Redis::List.new('visited')
  end
end
