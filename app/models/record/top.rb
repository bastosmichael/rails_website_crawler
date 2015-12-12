class Record::Top < Record::Match
  def sort(query_array = ['date'], options = { crawl: true, social: true, results: 10, fix: false })
    @options = options
    @query_array = query_array

    if !@container.nil? && !@container.include?(Rails.env)
      types = container.split('-').last.pluralize.gsub(':', '')
      @index = [ Rails.env + '-' + types ]
    elsif @container.nil?
      @index = Rails.configuration.config[:admin][:api_containers].map { |c| Rails.env + '-' + c.split('-').last.pluralize.gsub(':', '') }.uniq
    end

    @options = options
    sanitize_results
  end

  def elasticsearch_results
    Elasticsearch::Model.client.search(index: @index, body: query).deep_symbolize_keys!
  end

  def sanitize_results
    elasticsearch_results[:hits][:hits].map do |e|
      delete_bad_data e[:_source][:url] if @options[:fix]
      recrawl(e[:_source][:url], @options) if e[:_source][:url]

      new_data = { id: e[:_id],
                   container: e[:_type],
                   score: e[:_score],
                   history: {},
                   social: {},
                   price: {}
                 }

      e[:_source].each do |k,v|
        if k.to_s.include?('_history')
          new_data[:history][k.to_s.gsub('_history','')] = v
        elsif k.to_s.include?('facebook') || k.to_s.include?('_shares')
          new_data[:social][k] = v
        elsif k.to_s.include?('price')
          new_data[:price][k] = v
        else
          new_data[k] = v
        end
      end
      new_data
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

  def delete_bad_data url
    Recorder::UrlDeleter.perform_async url
  end
end
