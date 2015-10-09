class Page::Visit
  def initialize(links, type = 'Scrimper')
    @links = *links
    @type = type
    @name = Page::Url.new(@links.first).name
    @container = Rails.configuration.config[:admin][:api_containers].find { |c| c.include?(@name) }
    types = @container.split('-').last.pluralize.gsub(':', '')
    @index = Rails.env + '-' + types
  end

  def cache
    @links.each do |link|
      check_elasticsearch(link)
    end
  end

  def check_elasticsearch(url)
    if new_url = @name.capitalize.constantize.sanitize_url(url)
      if Elasticsearch::Model.client.search(index: @index, type: @container, body: { query: { match_phrase_prefix: { url: new_url } } })['hits']['total'] == 0
        check_redis(url)
      end
    end
  rescue NoMethodError => e
    if Elasticsearch::Model.client.search(index: @index, type: @container, body: { query: { match_phrase_prefix: { url: url } } })['hits']['total'] == 0
      check_redis(url)
    end
  end

  def check_redis(url)
    # key = Page::Url.new(url).cache_key
    # unless keys.include? key
    #   keys << key
    #   ap "#{list}: #{keys.count}"
      if @type == 'Sampler'
        Crawler::Scrimper.constantize.perform_async url
      else
        ('Crawler::' + @type).constantize.perform_async url
      end
    # end
  end

  def list
    @type.underscore + '_visited'
  end

  def keys
    @keys ||= Redis::List.new(list)
  end
end
