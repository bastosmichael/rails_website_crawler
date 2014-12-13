class Mapper::Cleaner < Mapper::Base

  def perform container
    @container = container
    records.with_progress.each do |r|
      data = record(r.key).data
      if id = data['id']
        data.with_progress.each do |k,v|
          ap k
          if value = v.is_a?(Hash)
            ap v.values
          else
            ap v
          end
        end
      end
    end
  end
end
