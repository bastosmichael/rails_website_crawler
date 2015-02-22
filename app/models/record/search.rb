class Record::Search < Record::Match
  alias_method :search, :best

  def match_query
    @query_hash.map do |k, v|
      {
        flt_field: {
          k => {
            like_text: v,
            analyzer: 'snowball',
            fuzziness: 0.6
          }
        }
      }
    end
  end
end
