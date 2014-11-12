class Mapper::Reader < Mapper::Base
  EXCLUDE = %i/site_name
               id
               type
               screenshot/.freeze

  def perform container
    @container = container
    records.with_progress.each do |r|
      data = record(r.key).data
      if id = data['id']
        data.with_progress.each do |k,v|
          value = v.is_a?(Hash) ? v.values.last : v
          launch_combiner(k, id, value) unless EXCLUDE.include? k.to_sym
        end
      end
    end
  end

  def launch_combiner item, id, value
    Mapper::Combiner.perform_async @container, item, id, value
  end
end
