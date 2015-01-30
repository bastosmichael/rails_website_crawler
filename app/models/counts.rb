class Counts
  def self.storage
    @storage ||= Fog::Storage.new(SETTINGS[:fog])
  end

  def self.directories
    @directories ||= storage.directories.map(&:key)
  end

  def self.visible_directories
    @visible_directories ||= directories.map {|d| d unless d.include?('-screenshots') || d.include?('api-keys') }.compact
  end

  def self.visible_counts
    hash = {}
    visible_directories.map { |c| hash[c] = Record::Base.new(c, '_names.json').data.keys.count }
    return hash
  end
end
