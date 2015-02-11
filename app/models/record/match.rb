class Record::Match < Record::Base
  require 'amatch'
  include Amatch

  def initialize(container, metadata = 'name')
    @container = container
    @record = "_#{metadata.pluralize}.json"
  end

  def find search
    @search = search
    return best if key.nil?
  end

  def best
    match_hash.each do |k,v|
      value = @search.levenshtein_similar(v)
      if value > max
        max = value
        key = k
      end
    end
  end

  def match_hash
    @match_hash ||= data
  end

  def max
    @max ||= 0.0
  end

  def key
    @key ||= nil
  end
end
