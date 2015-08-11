class Record::Top < Record::Base
  def sort(query_array = ['date'], options = { crawl: true, social: true, results: 10 })
    @options = options
    @query_array = query_array
    if !@container.nil? && !@container.include?(Rails.env)
      @container = Rails.env + '-' + @container
    elsif @container.nil?
      @container = Rails.configuration.config[:admin][:api_containers].map { |c| Rails.env + '-' + c }
    end
    @options = options
    sanitize_results
  end

  def elasticsearch_results
    Elasticsearch::Model.client.search(index: @container, body: query).deep_symbolize_keys!
  end

  def sanitize_results
    elasticsearch_results[:hits][:hits].each_with_index.map do |e, index|
      recrawl(e[:_source][:url], @options) if e[:_source][:url]
      { id: e[:_id],
        container: e[:_type],
        score: index + 1
      }.merge(e[:_source])
    end
  end

  def query
    @query =
    {
      filter: {
        match_all: { }
      },
      sort: sort_query,
      size: limit_results
    }
  end

  def sort_query
    @query_array.map do |n|
      {
        n => {
          order: "desc"
        }
      }
    end
  end

  def limit_results
    if !@options[:results]
      10
    elsif @options[:results] > 25
      25
    else
      @options[:results]
    end
  end
end
