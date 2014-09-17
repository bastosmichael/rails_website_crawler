class Results < Url
  CANONICAL = %i/site_name
                 id
                 url
                 type
                 date
                 name
                 image
                 description/.freeze

  attr_accessor :metadata
  attr_accessor :screenshot

  def sync
    self.data = update_metadata(update_canonical(data))
  end

  def update_canonical new_data = {}
    set_date
    set_screenshot
    metadata.each do |key, value|
      if CANONICAL.include? key.to_sym
        new_data[key] = value
        metadata.delete(key)
      end
    end
    return new_data
  end

  def update_metadata new_data = {}
    metadata.each do |key, value|
      if new_data[key]
        original_hash = new_data[key]
        new_hash = {}
        last_key = original_hash.keys.last
        original_hash.each do |k, v|
          if k == last_key && v != value
            new_hash[date] = value
            if screenshot
              new_data['screenshot'][date] = screenshot
              Screener.perform_async url, date
            end
          end
        end
        new_data[key] = original_hash.merge!(new_hash)
      else
        new_data[key] = {date => value}
        if screenshot
          if !new_data['screenshot']
            new_data['screenshot'] = { date => screenshot }
            Screener.perform_async url, date
          end
        end
      end
    end
    return new_data
  end

  def set_date
    self.date = metadata['date'] if metadata['date']
  end

  def set_screenshot
    if metadata['screenshot']
      self.screenshot = metadata['screenshot']
      metadata.delete('screenshot')
    end
  end

  def data
    JSON.parse(cloud.get(json_relative_path).try(:body), :quirks_mode => true)
  rescue
    {}
  end

  def data= new_hash = {}
    cloud.sync json_relative_path, new_hash.to_json
  end

  def json_relative_path
    md5 + '.json'
  end

  def cache_data
    File.join(host, types, md5)
  end

  def types
    metadata['type'].downcase.pluralize
  end

  def cloud
    @cloud ||= Cloud.new(name + '_' + types)
  end
end
