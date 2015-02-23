class Record::Search < Record::Match
  alias_method :search, :best

  def sanitize_results
    original_results = elasticsearch_results[:hits][:hits]
    uniq_results = original_results.map {|e| {_index: e[:_index], _id: e[:_id] } }.uniq

    uniq_results.map do |result|
      Record::Base.new(result[:_index], result[:_id] + '.json').current_data(@options).merge(container: result[:_index])#,match_score: result[:_score])
    end
  end

  def match_query
    cleanup_query
    @query_hash.map do |k, v|
      {
        flt_field: {
          k => {
            like_text: v,
            analyzer: 'snowball',
            fuzziness: 0.6          }
        }
      }
    end
  end

  def cleanup_query
    if @query_hash[:query]
      @query_hash[:name] = @query_hash[:query]
      # @query_hash[:description] = @query_hash[:query]
      @query_hash.delete(:query)
    end
  end
end
