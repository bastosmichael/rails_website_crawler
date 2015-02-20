class Mapper::Combiner < Mapper::Base
  def perform(container, type, id, value)
    Elasticsearch::Model.client.index index: container, type: type, id: id, body: { type => value }
  end
end
