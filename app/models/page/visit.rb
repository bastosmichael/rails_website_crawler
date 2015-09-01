class Page::Visit
  def initialize(links, type = 'Scrimper')
    @links = *links
    @type = type
    @name = Page::Url.new(@links.first).name
    @container = Rails.configuration.config[:admin][:api_containers].find { |c| c.include?(@name) }
    @index = Rails.env + '-' + @container
  end

  def cache
    @links.each do |link|
      new_url = @name.capitalize.constantize.sanitize_url(url)

      # key = Page::Url.new(link).cache_key
      # unless keys.include? key
      #   keys << key
      #   ap "#{list}: #{keys.count}"
      #   if @type == 'Sampler'
      #     Crawler::Scrimper.constantize.perform_async link
      #   else
      #     ('Crawler::' + @type).constantize.perform_async link
      #   end
      # end
    end
  end

  # def check_page(url)
  #   if new_url = @name.capitalize.constantize.sanitize_url(url)
  #     get_page(new_url) if Elasticsearch::Model.client.search(index: @index, type: @container, body: { query: { match_phrase_prefix: { url: new_url } } })['hits']['total'] == 0
  #   end
  # rescue NoMethodError => e
  #   get_page(url) if Elasticsearch::Model.client.search(index: @index, type: @container, body: { query: { match_phrase_prefix: { url: url } } })['hits']['total'] == 0
  # end

  def list
    @type.underscore + '_visited'
  end

  def keys
    @keys ||= Redis::List.new(list)
  end
end
