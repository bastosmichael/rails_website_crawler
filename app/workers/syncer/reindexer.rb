class Syncer::Reindexer < Syncer::Base
  def perform(container)
    @container = container
    types = container.split('-').last.pluralize.gsub(':', '')
    index = Rails.env + '-' + types
    Elasticsearch::Model.client.indices.refresh index: index
    records.with_progress("Remapping #{container}").each do |r|
      id = r.key.gsub('.json','')
      begin
        unless Elasticsearch::Model.client.exists? index: index, type: container, id: id
          # temp = Mapper::Indexer.new
          # temp.perform @container, id
          Mapper::Indexer.perform_async @container, id
        end
      rescue
        Mapper::Indexer.perform_async @container, id
      end
    end
  end
end
