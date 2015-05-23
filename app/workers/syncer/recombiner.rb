class Syncer::Recombiner < Syncer::Base
  CANONICAL = %i(site_name
                 id
                 url
                 type
                 date
                 name
                 image
                 description
                 tags
                 open_graph
                 schema_org).freeze

  EXCLUDE = %i(site_name
               id
               type
               screenshot).freeze

  def perform(container)
    @container = container
    records.with_progress.each do |r|
      data = record(r.key).data
      if id = data['id']
        data.with_progress.each do |k, v|
          value = v.is_a?(Hash) ? v.values.last : v
          unless EXCLUDE.include? k.to_sym
            launch_combiner(k, id, value)
            unless CANONICAL.include? k.to_sym
              launch_combiner(k + '_history', id, v.count) if v.count > 1
            end
          end
        end
      end
    end
  end

  def launch_combiner(item, id, value)
    Mapper::Combiner.perform_async @container, item, id, value
  end
end
