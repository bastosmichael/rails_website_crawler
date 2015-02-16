class Record::Match < Record::Base
  require 'amatch'
  include Amatch

  def initialize(container, metadata = 'name')
    @container = container
    @record = "_#{metadata.pluralize}.json"
  end

  def find_key search
    @search =  Tokenizer::Tokenizer.new.tokenize(search.downcase)
    return key if exact
    return key if best
  end

  def find_record search
    find_key(search) ? Record::Base.new(@container, key + '.json').current_data : {error: 'no match found'}
  end

  def exact
    @key = match_hash.key(@search)
  end

  def best
    match_hash.each do |k,v|
      value = Jaccard.coefficient(@search, v)
      if value > max
        @max = value
        @key = k
      end
    end
    return key
  end

  def match_hash
    @match_hash ||= Rails.cache.fetch('record_matcher_' + @container + @record, expires_in: 12.hours) do
      new_data = data
      new_data.each {|k,v| new_data[k] =  Tokenizer::Tokenizer.new.tokenize(v.downcase) }
      new_data
    end
  end

  def max
    @max ||= 0.0001
  end

  def key
    @key ||= nil
  end
end
