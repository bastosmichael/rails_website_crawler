class Recorder::Combiner < Recorder::Base

  def perform container, type, id, value
    @container = container
    @type = type
    combined_record.data = insert(id, value) unless combined_string.include? value
  end

  def insert id, value
    combined_record[id] = value
  rescue
    {id => value}
  end

  def combined_string
    combined_record.data.to_s
  end

  def combined_record
    @combined_record ||= record json_relative_path
  end

  def json_relative_path
    @file ||= '_' + @type.pluralize + '.json'
  end
end
