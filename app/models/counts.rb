class Counts
  def self.storage
    @storage ||= Fog::Storage.new(SETTINGS[:fog])
  end

  def self.directories
    @directories ||= storage.directories.map(&:key)
  end

  def self.directories_count
    @directories_count ||= Rails.cache.fetch(directories, expires_at: 12.hours) do
      hash = {}
      directories.map { |c| hash[c] = Cloud.new(c).count }
      return hash
    end
  end

  def self.visible_directories
    @visible_directories ||= directories.map {|d| d unless d.include?('-screenshots') || d.include?('api-keys') }.compact
  end

  def self.visible_counts
    @visible_counts ||= Rails.cache.fetch(directories, expires_at: 12.hours) do
      hash = {}
      visible_directories.map { |c| hash[c] = Cloud.new(c).count }
      return hash
    end
  end
end
