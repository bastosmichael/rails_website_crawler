class Results < Url
  attr_accessor :metadata

  def save

  end

  def data
  	@data ||= cloud.get(json_relative_path) || {}
  end

  def data= hash = {}
  	cloud.sync json_relative_path, hash.to_json
  end

  def json_relative_path
  	cache_data + '.json'
  end

  def cache_data
  	File.join(host, metadata['type'].downcase.pluralize, md5)
  end

  def cloud
    @cloud ||= Cloud.new(name + '_results')
  end
end

# metadata.each do |key, value|
#   if listing.fields[key]
#     original_hash = eval(listing.fields[key])
    
#     new_hash = {}
    
#     last_key = original_hash.keys.last
    
#     original_hash.each do |k, v|
    
#       if k == last_key && v != value
#         new_hash["#{Time.now.utc}"] = value
#         # changes << key
#       end
    
#     end
    
#     listing.fields[key] = original_hash.merge!(new_hash)
#   else
#     listing.fields[key] = {"#{Time.now.utc}" => value}
#   end
# end