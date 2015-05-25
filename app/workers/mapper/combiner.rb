class Mapper::Combiner < Mapper::Base
  def perform(container, type, id, value)
    index = Rails.env + '-' + container
    if Elasticsearch::Model.client.exists? index: index, type: container, id: id
      source = Elasticsearch::Model.client.get_source index: index, type: container, id: id
      Elasticsearch::Model.client.index index: index, type: container, id: id, body: source.merge(type => value).sort.to_h
    else
      Elasticsearch::Model.client.index index: index, type: container, id: id, body: { type => value }
    end
  end
end
