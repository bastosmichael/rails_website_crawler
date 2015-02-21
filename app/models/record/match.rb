class Record::Match < Record::Base
  def search query_hash = {}, mapping = false, results = 1
    @query_hash = query_hash.delete_if { |_k, v| v.nil? || v.blank? }
    @results = results
    @mapping = mapping
    sanitize_results
  end

  def results
    Elasticsearch::Model.client.search(index: @container, body: query).deep_symbolize_keys!
  end

  def sanitize_results
    results[:hits][:hits].map do |result|
      @record = result[:_id] + '.json'
      new_data = current_data @mapping
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
      size: @results
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
end
