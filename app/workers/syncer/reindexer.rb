class Syncer::Reindexer < Syncer::Base
  def perform(container)
    @container = container
    index = Rails.env + '-' + container
    Elasticsearch::Model.client.indices.refresh index: index
    records.with_progress("Remapping #{container}").each do |r|
      id = r.key.tr('.json','')
      unless Elasticsearch::Model.client.exists? index: index, type: container, id: id
        Mapper::Indexer.perform_async @container, id
      end
    end
  end
end
