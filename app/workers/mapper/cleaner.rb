class Mapper::Cleaner < Mapper::Base

  def perform container, standard = []
    @container = container
    records.with_progress.each do |r|
      data = record(r.key).data
      new_data = parse_record data
      record(r.key).data = new_data unless data == new_data
    end
  end

  def parse_record data
    if id = data['id']
      data.with_progress.each do |k,v|
        ap 'KEY'
        ap k
        if v.is_a?(Hash)
          v.each do |k2, v2|
            ap '!!!!!!!!!!!!INNER KEY'
            ap k2
            ap '!!!!!!!!!!!!INNER VALUE'
            ap v2
          end
        else
          ap 'VALUE'
          ap v
        end
      end
    end
    data
  end
end
