class Record::Search < Record::Match
  alias_method :search, :best

  def match_query
    cleanup_query
    @query_hash.map do |k, v|
      {
        flt_field: {
          k => {
            like_text: v,
            analyzer: 'snowball',
            fuzziness: 0.7
          }
        }
      }
    end
  end

  def cleanup_query
    if @query_hash[:query]
      @query_hash[:name] = @query_hash[:query]
      @query_hash[:description] = @query_hash[:query]
      @query_hash.delete(:query)
    end
  end
end
