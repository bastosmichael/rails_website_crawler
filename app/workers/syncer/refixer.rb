class Syncer::Refixer < Syncer::Base
  def perform(container)
    @container = container
    types = container.split('-').last.pluralize.gsub(':', '')
    index = Rails.env + '-' + types
    Elasticsearch::Model.client.indices.refresh index: index
    records.with_progress("Refixing #{container}").each do |r|
      id = r.key.gsub('.json','')
      if id.size > 20
        r = record(id)
        if url = r.try(:url)
          Crawler::Scrimper.perform_async url
        end
        r.delete
      end
    end
  end
end
