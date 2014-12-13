class Record::Upload < Page::Url
  CANONICAL = %i(site_name
                 id
                 url
                 type
                 date
                 name
                 image
                 description
                 tags
                 open_graph
                 schema_org).freeze

  EXCLUDE = %i/site_name
               id
               type
               screenshot/.freeze

  attr_accessor :metadata
  attr_accessor :id
  attr_accessor :screenshot

  def sync
    self.data = update_metadata(update_canonical(data))
  end

  def update_canonical(new_data = {})
    types
    set_date
    set_screenshot
    metadata.each do |key, value|
      if CANONICAL.include? key.to_sym
        unless new_data[key] == value
          new_data[key] = value
          launch_combiner(key, value) unless EXCLUDE.include? key.to_sym
        end
        metadata.delete(key)
      end
    end
    new_data
  end

  def update_metadata(new_data = {})
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
              launch_screener
            end
            launch_combiner key, value unless EXCLUDE.include? key.to_sym
          end
        end
        new_data[key] = original_hash.merge!(new_hash)
      else
        new_data[key] = { date => value }
        if screenshot
          unless new_data['screenshot']
            new_data['screenshot'] = { date => screenshot }
            launch_screener
          end
        end
        launch_combiner key, value unless EXCLUDE.include? key.to_sym
      end
    end
    new_data
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

  def launch_screener
    Crawler::Screener.perform_async url, screenshot
  end

  def launch_combiner item, value
    Mapper::Combiner.perform_async container, item, id, value
  end

  def data
    return record.data if record.data
    {}
  end

  def data=(new_data)
    record.data = new_data
  end

  def record
    @data ||= Record::Base.new(container, json_relative_path)
  end

  def json_relative_path
    @json_relative_path ||= id ? id + '.json' : md5 + '.json'
  end

  def types
    @types ||= metadata['type'].downcase.pluralize.gsub(':', '')
  end

  def container
    @container ||= name + '-' + types
  end
end
