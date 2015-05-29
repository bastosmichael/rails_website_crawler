class Syncer::Recombiner < Syncer::Base
  def perform(container)
    @container = container
    records.with_progress.each do |r|
      data = record(r.key).data
      id = data['id']
      new_data = {}
      record(r.key).data.with_progress.each do |k, v|
        unless Record::Upload::EXCLUDE.include? k.to_sym
          new_data[k] = v.is_a?(Hash) ? v.values.last : v
          new_data[k + '_history'] = v.count if v.is_a?(Hash) && v.count > 1
        end
      end
      launch_combiner(id, new_data)
    end
  end

  def launch_combiner(id, hash = {})
    Mapper::Combiner.perform_async @container, id, hash
  end
end
