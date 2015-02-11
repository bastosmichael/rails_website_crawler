class Record::Match < Record::Base
  def initialize(container, metadata = 'name')
    @container = container
    @record = "_#{metadata.pluralize}.json"
  end

  def max
    @max ||= 0.0
  end

  def key
    @key ||= nil
  end
end
