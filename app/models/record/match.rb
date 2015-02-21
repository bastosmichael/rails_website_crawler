class Record::Match < Record::Base
  def search query_hash = {}, options = { mapping: false, social: false, results: 1 }
    @query_hash = query_hash.delete_if { |_k, v| v.nil? || v.blank? }
    @options = options
    sanitize_results
  end

  def elasticsearch_results
    Elasticsearch::Model.client.search(index: @container, body: query).deep_symbolize_keys!
  end

  def sanitize_results
    elasticsearch_results[:hits][:hits].map do |result|
      @record = result[:_id] + '.json'
      new_data = current_data @options
      @record = nil
      new_data.merge(score: result[:_score])
    end
  end

  def query
    @query = {
      query: {
        bool: {
          should: flt_fields
        }
      },
      size: limit_results
    }
  end

  def flt_fields
    @query_hash.map do |k, v|
      {
        flt_field: {
          k => {
            like_text: v
          }
        }
      }
    end
  end

  def limit_results
    if !@options[:results]
      1
    elsif @options[:results] > 10
      10
    else
      @options[:results]
    end
  end
end
