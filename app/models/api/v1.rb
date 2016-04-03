class Api::V1 < Record::Base
  MAX_BATCH = 50

  def batch(batch_hash = {}, options = { crawl: true, social: false, history: false, results: 10 })
    @options = options
    @batch_hash = batch_hash

    if batch_hash.values.flatten.count > MAX_BATCH
      return { error: 'exceeded maximum number of ids: ' + MAX_BATCH }
    else
      batch_hash.with_progress.map do |key, value|
        @container = key
        if value.kind_of?(Array)
          value.map do |id|
            @record = id
            if options[:history]
              historical_data(options)
            else
              current_data(options)
            end
          end
        else
          return { error: 'ids must be given as an array' }
        end
      end.flatten
    end
  end

  def current_data(options = { crawl: true, social: false })
    return { id: @record, container: @container, error: 'not available' } unless old_data = data
    new_data = { id: nil,
                 container: @container,
                 name: name(old_data),
                 social: {},
                 price:{}
               }

    old_data.each do |k, v|

      if v.is_a?(Hash)
        if k.include?('_shares')
          new_data[:social][k] = sanitize_value(v.values.last)
        elsif k.include?('price')
          new_data[:price][k] = sanitize_value(v.values.last)
        else
          new_data[k] = sanitize_value(v.values.last)
        end
      else
        if k.include?('_shares')
          new_data[:social][k] = sanitize_value(v)
        elsif k.include?('price')
          new_data[:price][k] = sanitize_value(v)
        else
          new_data[k] = sanitize_value(v)
        end
      end
    end if old_data['id']
    recrawl(old_data['url'], options) if old_data['url']
    new_data.deep_symbolize_keys!
  end

  def historical_data(options = { crawl: true, social: false })
    return { id: @record, container: @container, error: 'not available' } unless old_data = data
    new_data = {}
    old_data.each do |k, v|
      if v.is_a?(Hash) && v.count > 1
        new_data[k] = v.merge({Date.today.to_s => v.values.last}).group_by_week {|k,v| k }.map do |k,v|
          if value = v.try(:first).try(:last)
            @last = sanitize_value(value)
          end
          {k.to_date => @last}
        end.inject({},:merge)
      end
    end if old_data['id']
    recrawl(old_data['url'], options) if old_data['url']

    if new_data.empty?
      {
        id: old_data['id'],
        container: @container,
        name: name(old_data),
        error: 'no history available'
      }
    else
      {
        id: old_data['id'],
        container: @container,
        name: name(old_data),
        history: new_data.deep_symbolize_keys!
      }
    end
  end

  def related_data(options = { crawl: true, social: false })
    return { id: @record, container: @container, error: 'not available' } unless name

    @containers = containers - [@container]

    query = initial_query({
        match: {
          name: name
        }
      })

    related = sanitize_results(@containers, query, options)

    if related.any?
      {
        id: @record,
        container: @container,
        name: name,
        related: related
      }
    else
      {
        id: @record,
        container: @container,
        name: name,
        error: 'no related available'
      }
    end
  end

  def links_data(options = { crawl: true, social: false })
    return { id: @record, container: @container, error: 'not available' } unless name

    links = Crawl::Google.new(name).links

    if links
      {
        id: @record,
        container: @container,
        name: name,
        links: links
      }
    else
      {
        id: @record,
        container: @container,
        name: name,
        error: 'no links available'
      }
    end
  end

  def references_data(options = { crawl: true, social: false })
    return { id: @record, container: @container, error: 'not available' } unless name

    references = Crawl::Google.new(name).references

    if references
      {
        id: @record,
        container: @container,
        name: name,
        references: references
      }
    else
      {
        id: @record,
        container: @container,
        name: name,
        error: 'no references available'
      }
    end
  end

  def news_data(options = { crawl: true, social: false })
    return { id: @record, container: @container, error: 'not available' } unless name

    news = Crawl::Google.new(name).news

    if news
      {
        id: @record,
        container: @container,
        name: name,
        news: news
      }
    else
      {
        id: @record,
        container: @container,
        name: name,
        error: 'no news available'
      }
    end
  end

  def videos_data(options = { crawl: true, social: false })
    return { id: @record, container: @container, error: 'not available' } unless name

    videos = Crawl::Google.new(name).videos

    if videos
      {
        id: @record,
        container: @container,
        name: name,
        videos: videos
      }
    else
      {
        id: @record,
        container: @container,
        name: name,
        error: 'no videos available'
      }
    end
  end

  def ids options = {}
    limit_results = options[:results].try(:to_i) || 10
    elasticsearch_results = Elasticsearch::Model.client.search(index: @index, type: @container, body: {query: {match_all: {}}, size: limit_results, from: (((options[:page].try(:to_i) || 1) - 1) * 30), fields: ["_id"]})
    {
      result: {
        container: @container,
        ids: (elasticsearch_results['hits']['hits'].map {|h| h['_id'] } if elasticsearch_results['hits'] || []),
      },
      total: ((elasticsearch_results['hits']['total'] if elasticsearch_results['hits'] || 0) / limit_results.to_f / 3).ceil
    }
  end

  def name hash = {}
    Rails.cache.fetch("#{@container}/#{@record}/name", expires_in: 30.days) do
      if saved_name = hash['name']
        return saved_name
      else
        data['name']
      end
    end
  end

  def containers
    Rails.configuration.config[:admin][:api_containers]
  end

  def types
    @container.split('-').last.pluralize.gsub(':', '')
  end

  def index
    unless @container.nil?
      [ Rails.env + '-' + types ]
    else
      @container.map { |c| Rails.env + '-' + c.split('-').last.pluralize.gsub(':', '') }.uniq
    end
  end

  def elasticsearch_results containers, query
    Elasticsearch::Model.client.search(index: index, type: containers, body: query).deep_symbolize_keys!
  end

  def sanitize_results containers, query, options
    elasticsearch_results(containers, query)[:hits][:hits].map do |e|
      recrawl(e[:_source][:url], options) if e[:_source][:url]

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

  def initial_query hash = {}
    {
      query: {
        bool: {
          should: hash
        }
      }
    }
  end
end
