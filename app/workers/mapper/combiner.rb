class Mapper::Combiner < Mapper::Base
  def perform(container, id, hash = {})
    index = Rails.env + '-' + container
    new_hash = {}

    hash.with_progress.each do |k, v|
      unless Record::Upload::EXCLUDE.include? k.to_sym
        new_hash[k] = v.is_a?(Hash) ? v.values.last : v
        new_hash[k + '_history'] = v.count if v.is_a?(Hash) && v.count > 1
      end
    end

    Elasticsearch::Model.client.index index: index, type: container, id: id, body: new_hash.sort.to_h
  end
end
