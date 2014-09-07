class Visit
  def initialize links
  	links = *links
  	links.each do |link|
      visit link
    end
  end

  def visit link
  	key = Url.new(link).cache_key
  	if !keys.include? key
  	  keys << key
  	  push_job link
  	end
  end

  def push_job link
    Spider.perform_async link
  end

  def keys
  	@keys ||= Redis::List.new('visited')
  end
end