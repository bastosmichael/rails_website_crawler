class Recorder::Fixer < Recorder::Base
  def perform(container = nil, record = nil)
    if container && record
      new_hash = Record::Base.new(container, record).data
      new_hash.delete('screenshot')

      if new_hash['price']
        new_hash['price'] = new_hash['price'].delete_if {|k,v| v.include?('-') }
        new_hash.delete('price') if new_hash['price'].blank?
      end

      if new_hash['original_price']
        new_hash['original_price'] = new_hash['original_price'].delete_if {|k,v| v.include?('-') }
        new_hash.delete('original_price') if new_hash['original_price'].blank?
      end

      Record::Base.new(container, record).data = new_hash
      Crawler::Slider.perform_async new_hash['url']
    end
  end
end
