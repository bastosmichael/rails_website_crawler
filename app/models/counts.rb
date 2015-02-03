class Counts
  include Singleton

  def storage
    @storage ||= Fog::Storage.new(SETTINGS[:fog])
  end

  def directories
    storage.directories.map(&:key)
  end

  def visible_directories
    directories.map {|d| d unless d.include?('-screenshots') || d.include?('api-keys') }.compact
  end

  def visible_counts
    hash = { available: {},
             actively_mapping: Sidekiq::Queue.new('mapper').size,
             currently_processing: Sidekiq::Queue.new('scrimper').size,
             still_in_sitemaps: Sidekiq::Queue.new('sitemapper').size * 50_000 }
    visible_directories.map { |c| hash[:available][c] = Record::Base.new(c, '_names.json').data.keys.count }
    return hash
  end
end
