class Syncer::Recombiner < Syncer::Base
  EXCLUDE = %i(site_name
               id
               type
               screenshot).freeze

  def perform(container, metadata = 'name')
    @container = container
    @metadata = "_#{metadata.pluralize}.json"
    records.with_progress.each do |r|
      unless mapped_keys.include?(r.key)
        data = record(r.key).data
        if id = data['id']
          data.with_progress.each do |k, v|
            value = v.is_a?(Hash) ? v.values.last : v
            launch_combiner(k, id, value) unless EXCLUDE.include? k.to_sym
          end
        end
      end
    end
  end

  def mapped_keys
    @mapped_keys ||= Record::Base.new(@container, @metadata).data.keys.map {|r| r + '.json' }
  end

  def launch_combiner(item, id, value)
    Mapper::Combiner.perform_async @container, item, id, value
  end
end
