class Counts
  include Singleton

  def storage
    @storage ||= Fog::Storage.new(Rails.configuration.config['fog'].symbolize_keys!)
  end

  def directories
    storage.directories.map(&:key)
  end

  def visible_directories
    directories.map {|d| d unless d.include?('-screenshots') || d.include?('api-keys') }.compact
  end

  # def total_visible_counts
  #   hash = { available: {},
  #            mapping: Sidekiq::Queue.new('mapper').size,
  #            processing: Sidekiq::Queue.new('scrimper').size,
  #            pending: Sidekiq::Queue.new('sitemapper').size * 50_000 }
  #   visible_directories.map { |c| hash[:available][c] = Record::Base.new(c, '_names.json').data.keys.count }
  #   return hash
  # end

  def visible_counts container = nil
    return 0 if container.nil?
    Record::Base.new(container, '_names.json').data.keys.count
  rescue
    'still mappping'
  end
end
