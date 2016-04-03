class Record::Base
  def initialize(container = nil, record = nil)
    @record = record
    @container = container
    @types = container.split('-').last.pluralize.gsub(':', '') if container
    @index = Rails.env + '-' + @types if @types
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
