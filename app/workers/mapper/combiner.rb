class Mapper::Combiner < Mapper::Base
  def perform(container, id, hash = {})
    index = Rails.env + '-' + container
    Elasticsearch::Model.client.index index: index, type: container, id: id, body: hash.sort.to_h
  end
end
