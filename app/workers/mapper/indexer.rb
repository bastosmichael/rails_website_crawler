class Mapper::Indexer < Mapper::Base
  def perform(container, id, hash = nil)
    @container = container
    types = container.split('-').last.pluralize.gsub(':', '')
    hash = record(id + '.json').data if hash.nil?
    index = Rails.env + '-' + types
    new_hash = {}

    hash.with_progress("Mapping #{index}: #{id}").each do |k, v|
      unless Record::Upload::EXCLUDE.include? k.to_sym
        if v.is_a?(Hash)
          value = v.values.last

          if value.is_a?(Array) || !!value == value
            new_hash[k] = value
          elsif value.to_i.to_s == value.to_s
            new_hash[k] = value.to_i
          elsif (Float(value) rescue false)
            new_hash[k] = value.to_f
            new_hash[k] = value if new_hash[k].infinite?
          else
            new_hash[k] = value
          end

          new_hash[k + '_history'] = v.count if v.count > 1
        elsif !!v == v # Check if Boolean
          new_hash[k] = v
        elsif v.is_a?(Array)
          new_hash[k] = v.map {|value| value.encode(Encoding.find('UTF-8'), {invalid: :replace, undef: :replace, replace: ''}) }
        else
          new_hash[k] = v.encode(Encoding.find('UTF-8'), {invalid: :replace, undef: :replace, replace: ''})
        end
      end
    end

    Elasticsearch::Model.client.index index: index, type: container, id: id, body: new_hash.sort.to_h

    Elasticsearch::Model.client.indices.refresh index: index
  rescue Elasticsearch::Transport::Transport::Errors::BadRequest => e
   record(id + '.json').delete
   Crawler::Slider.perform_async new_hash['url'] if new_hash['url']
  end
end
