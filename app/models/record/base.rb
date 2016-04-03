class Record::Base
  def initialize(container = nil, record = nil)
    @record = record
    @container = container
    @types = container.split('-').last.pluralize.gsub(':', '') if container
    @index = Rails.env + '-' + @types if @types
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

  def delete
    cloud.head(@record + '.json').try(:destroy)
  end

  def url
    @url ||= data['url']
  end

  def screenshots
    @screenshots ||= data['screenshot'].map { |_key, value| { value => url } }.reduce({}, :merge)
  end

  def data
    JSON.parse(cloud.get(@record + '.json').try(:body), quirks_mode: true)
  rescue
    {}
  end

  def data=(new_hash = {})
    cloud.sync @record + '.json', new_hash.to_json
  end

  def cloud
    Cloud.new(@container)
  end

  private

  def sanitize_value value
    if value.is_a?(Array) || !!value == value
      return value
    elsif value.to_i.to_s == value.to_s
      return value.to_i
    elsif (Float(value) rescue false)
      return value.to_f
    else
      return value
    end
  end

  def recrawl(url, options)
    if options[:crawl]
      options[:social] ? Crawler::Socializer.perform_async(url) : Crawler::Slider.perform_async(url)
    end
  rescue #TODO find the correct error for Redis not responding
    nil
  end
end
