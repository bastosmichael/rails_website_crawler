class Mapper::Combiner < Mapper::Base
  def perform(container, type, id, value)
    @container = container
    @type = type
    @id = id
    @value = value
    combined_record.data = insert(id, value) unless combined_string.include?(value.to_s) && combined_string.include?(id.to_s)
  end

  def insert id, value
    hash = combined_record.data || {}
    hash.merge(new_hash)
  end

  def new_hash
    {@id => @value}
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
