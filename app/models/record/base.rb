class Record::Base
  def initialize(container = nil, record = nil)
    @record = record
    @container = container
  end

  def delete
    cloud.head(@record).try(:destroy)
  end

  def url
    @url ||= data['url']
  end

  def screenshots
    @screenshots ||= data['screenshot'].map { |_key, value| { value => url } }.reduce({}, :merge)
  end

  def data
    JSON.parse(cloud.get(@record).try(:body), quirks_mode: true)
  rescue
    {}
  end

  def current_data(options = { crawl: true, social: false })
    return { error: 'not available' } unless old_data = data
    new_data = {}
    old_data.with_progress("Current Data #{@container}: #{old_data['id']}").each do |k, v|
      if v.is_a?(Hash)
        new_data[k] = sanitize_value(v.values.last)
      else
        new_data[k] = sanitize_value(v)
      end
    end if old_data['id']
    recrawl(old_data['url'], options) if old_data['url']
    new_data.deep_symbolize_keys!
  end

  def historical_data(options = { crawl: true, social: false })
    return { error: 'not available' } unless old_data = data
    new_data = { id: old_data['id'],
                 name: old_data['name'] }
    old_data.with_progress("Historical Data #{@container}: #{old_data['id']}").each do |k, v|
      if v.is_a?(Hash) && v.count > 1
        new_data[k] = v.group_by_day {|k,v| k }.map do |k,v|
          if value = v.try(:first).try(:last)
            @last = sanitize_value(value)
          end
          {k.to_date => @last}
        end.inject({},:merge)
      end
    end if old_data['id']
    recrawl(old_data['url'], options) if old_data['url']
    new_data.deep_symbolize_keys!
  end

  def data=(new_hash = {})
    cloud.sync @record, new_hash.to_json
  end

  def cloud
    @cloud ||= Cloud.new(@container)
  end

  private

  def sanitize_value value
    if value.is_a?(Array)
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
  end
end
