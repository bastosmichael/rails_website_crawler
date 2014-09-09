class Results < Url
  CANONICAL = %i/site_name 
                 id 
                 url 
                 type 
                 date 
                 name 
                 image 
                 description 
                 schema_org 
                 open_graph/.freeze

  attr_accessor :metadata

  def save
    self.data = update_metadata(update_canonical(data))
  end

  def update_canonical new_data
    date = metadata['date'] if date_exists?
    metadata.each do |key, value|
      if CANONICAL.include? key.to_sym
        new_data[key] = value
        metadata.delete(key)
      end
    end
  end

  def update_metadata new_data
    metadata.each do |key, value|
      if new_data[key]
        original_hash = new_data[key]
        new_hash = {}
        last_key = original_hash.keys.last
        original_hash.each do |k, v|
          if k == last_key && v != value
            new_hash[date] = value
          end
        end
        new_data[key] = original_hash.merge!(new_hash)
      else
        new_data[key] = {date => value}
      end
    end
    new_data
  end

  def data
  	@data ||= cloud.get(json_relative_path) || {}
  end

  def data= hash = {}
  	cloud.sync json_relative_path, hash.to_json
  end

  def json_relative_path
  	build_path + '.json'
  end

  def cache_data
  	File.join(host, types, md5)
  end

  def types
    metadata['type'].downcase.pluralize
  end

  def date_exists?
    metadata['date']
  end

  def cloud
    @cloud ||= Cloud.new(name + '_' + types)
  end
end
