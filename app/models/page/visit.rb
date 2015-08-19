class Page::Visit
  def initialize(links, type)
    @links = *links
    @type = type
  end

  def cache
    @links.each do |link|
      key = Page::Url.new(link).cache_key
      unless keys.include? key
        keys << key
        ap "#{list}: #{keys.count}"
        if @type == 'Sampler'
          Crawler::Scrimper.constantize.perform_async link
        else
          ('Crawler::' + @type).constantize.perform_async link
        end
      end
    end
  end

  def list
    @type.underscore + '_visited'
  end

  def keys
    @keys ||= Redis::List.new(list)
  end
end
