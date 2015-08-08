class Record::Match < Record::Base
  def best(query_hash = {}, options = { crawl: true, social: false, results: 1 })
    @options = options
    @query_hash = query_hash.delete_if { |_k, v| v.nil? || v.blank? }
    if !@container.nil? && !@container.include?(Rails.env)
      @container = [ Rails.env + '-' + @container ]
    elsif @container.nil?
      @container = Rails.configuration.config[:admin][:api_containers].map { |c| Rails.env + '-' + c }
    end
    @options = options
    { results: sanitize_results }
  end

  def elasticsearch_results container
    Elasticsearch::Model.client.search(index: container, body: query).deep_symbolize_keys!
  end

  def sanitize_results
    @container.flat_map do |container|
      elasticsearch_results(container)[:hits][:hits].each_with_index.map do |e, index|
        recrawl(e[:_source][:url], @options) if e[:_source][:url]
        { id: e[:_id],
          container: e[:_type],
          score: e[:_score]
        }.merge(e[:_source]).merge(placement: index)
      end
    end.sort_by {|h| h[:score] }.reverse
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
