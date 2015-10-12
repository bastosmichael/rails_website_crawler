class Record::Search < Record::Match
  alias_method :search, :best

  def match_query
    [
      # {
      #   match: {
      #     name: @query_hash[:query]
      #   }
      # },
      # {
      #  match: {
      #    description: @query_hash[:query]
      #   }
      # },
      # {
      #   match: {
      #     url: @query_hash[:query]
      #   }
      # },
      # {
      #   match: {
      #     tags: @query_hash[:query]
      #   }
      # },
      # {
      #   match: {
      #     categories: @query_hash[:query]
      #   }
      # },
      {
        flt_field: {
          name: {
            like_text: @query_hash[:query],
            analyzer: 'snowball',
            fuzziness: 0.9,
            boost: 5
          }
        }
      },
      {
        flt_field: {
          url: {
            like_text: @query_hash[:query],
            analyzer: 'snowball',
            fuzziness: 0.7
          }
        }
      },
      {
        flt_field: {
          tags: {
            like_text: @query_hash[:query],
            analyzer: 'snowball',
            fuzziness: 0.3
          }
        }
      },
      {
        flt_field: {
          categories: {
            like_text: @query_hash[:query],
            analyzer: 'snowball',
            fuzziness: 0.5
          }
        }
      },
      {
        flt_field: {
          description: {
            like_text: @query_hash[:query],
            analyzer: 'snowball',
            fuzziness: 0.1
          }
        }
      },
    ]
  end
end
