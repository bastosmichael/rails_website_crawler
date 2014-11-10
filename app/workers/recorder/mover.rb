class Recorder::Mover < Recorder::Base
  def perform(from_container, to_container)
    @container = from_container
    @to_container = to_container
    records.each do |r|
      from_record = record(r.key)
      old_data = from_record.data
      old_data['type'] = new_type
      to_record(r.key).data = old_data
      from_record.delete
    end
  end

  def new_type
    @new_type ||= @to_container.match(/-(.+)/)[1].try(:singularize).try(:capitalize) rescue nil
  end

  def to_record(new_record)
    Record::Base.new(@to_container, new_record)
  end

  def to_cloud
    @to_cloud ||= Cloud.new(@to_container)
  end
end
