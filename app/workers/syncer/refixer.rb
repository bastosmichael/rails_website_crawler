class Syncer::Refixer < Syncer::Base
  def perform(container)
    @container = container
    types = container.split('-').last.pluralize.gsub(':', '')
    index = Rails.env + '-' + types
    Elasticsearch::Model.client.indices.refresh index: index
    records.with_progress("Refixing #{container}").each do |r|
      id = r.key.gsub('.json','')
      if id.size > 20
        begin
          Elasticsearch::Model.client.delete index: index, type: container, id: id
          Elasticsearch::Model.client.indices.refresh index: index
          r = record(id)
          if url = r.try(:url)
            Crawler::Scrimper.perform_async url
          end
          r.delete
        rescue
          Mapper::IdAvailability.perform_async container, id
        end
      end
    end
  end
end
