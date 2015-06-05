class Syncer::Recombiner < Syncer::Base
  def perform(container)
    @container = container
    index = Rails.env + '-' + container
    records.with_progress("Remapping #{container}").each do |r|
      id = r.key.tr('.json','')
      unless Elasticsearch::Model.client.exists? index: index, type: container, id: id
        data = record(r.key).data
        Mapper::Combiner.perform_async @container, id, data
      end
    end
  end
end
