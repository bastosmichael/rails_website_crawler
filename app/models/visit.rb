class Visit
  def initialize links
  	@links = *links
  end

  def spider
    @links.each do |link|
      key = Url.new(link).cache_key
      if !keys.include? key
        keys << key
        Spider.perform_async link
      end
    end
  end

  def sample
    @links.each do |link|
      key = Url.new(link).cache_key
      if !keys.include? key
        keys << key
        Scrimper.perform_async link
      end
    end
  end

  def keys
  	@keys ||= Redis::List.new('visited')
  end
end
