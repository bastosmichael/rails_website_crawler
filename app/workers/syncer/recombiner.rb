class Syncer::Recombiner < Syncer::Base
  def perform(container)
    @container = container
    records.with_progress.each do |r|
      data = record(r.key).data
      id = data['id']
      Mapper::Combiner.perform_async @container, id, data
    end
  end
end
