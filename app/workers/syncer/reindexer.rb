class Syncer::Reindexer < Syncer::Base
  def perform(container)
    @container = container
    types = container.split('-').last.pluralize.gsub(':', '')
    index = Rails.env + '-' + types
    Elasticsearch::Model.client.indices.refresh index: index
    records.with_progress("Remapping #{container}").each do |r|
      id = r.key.gsub('.json','')
      unless Elasticsearch::Model.client.exists? index: index, type: container, id: id
        Mapper::Indexer.perform_async @container, id
      end
    end
  end
end
