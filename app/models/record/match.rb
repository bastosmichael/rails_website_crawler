class Record::Match < Record::Base
  def best query_hash = {}, options = { crawl: true, social: false, results: 1 }
    @query_hash = query_hash.delete_if { |_k, v| v.nil? || v.blank? }
    if !@container.nil? && !@container.include?(Rails.env)
      @container = Rails.env + '-' + @container
    elsif @container.nil?
      @types = Rails.configuration.config[:admin][:api_containers].map {|c| Rails.env + '-' + c }
    end
    @options = options
    { results: sanitize_results }
  end

  def elasticsearch_results
    Elasticsearch::Model.client.search(index: @container, body: query).deep_symbolize_keys!
  end

  def sanitize_results
    elasticsearch_results[:hits][:hits].map {|e| { id: e[:_source],
                                                   score: e[:_score],
                                                   container: e[:_type]
                                                 }.merge(e[:_source]) }
  end

  def query
    @query = {
      query: {
        bool: {
          should: match_query
        }
      },
      size: limit_results
    }
  end

  def match_query
    @query_hash.map do |k, v|
      {
        match: {
          k => v
        }
      }
    end
  end

  def limit_results
    if !@options[:results]
      1
    elsif @options[:results] > 25
      25
    else
      @options[:results]
    end
  end
end
