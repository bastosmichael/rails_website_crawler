class Mapper::Combiner < Mapper::Base
  def perform(container, type, id, value)
    Elasticsearch::Model.client.index index: Rails.env + '-' + container, type: container, id: id, body: { type => value }
  end
end
