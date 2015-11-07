class Record::Match < Record::Base
  def best(query_hash = {}, options = { crawl: true, social: false, results: 1 })
    @options = options
    @query_hash = query_hash.delete_if { |_k, v| v.nil? || v.blank? }

    if !@container.nil? && !@container.include?(Rails.env)
      types = container.split('-').last.pluralize.gsub(':', '')
      @index = [ Rails.env + '-' + types ]
    elsif @container.nil?
      @container = Rails.configuration.config[:admin][:api_containers]
      @index = @container.map { |c| Rails.env + '-' + c.split('-').last.pluralize.gsub(':', '') }.uniq
    end

    @options = options
    sanitize_results
  end

  def elasticsearch_results
    Elasticsearch::Model.client.search(index: @index, type: @container, body: query).deep_symbolize_keys!
  end

  def sanitize_results
    elasticsearch_results[:hits][:hits].map do |e|
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
          new_data[:history][k.gsub('_history','')] = v
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
