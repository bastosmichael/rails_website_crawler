class Mapper::IdAvailability < Recorder::Base
  def perform(container, id)
    @container = container
    types = container.split('-').last.pluralize.gsub(':', '')
    index = Rails.env + '-' + types
    cloud.head(id + '.json').try(:destroy)
    Elasticsearch::Model.client.delete index: index, type: container, id: id
    Elasticsearch::Model.client.indices.refresh index: index
  end
end
