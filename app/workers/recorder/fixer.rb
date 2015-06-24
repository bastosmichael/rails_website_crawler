class Recorder::Fixer < Recorder::Base
  def perform(container = nil, record = nil)
    if container && record
      new_hash = Record::Base.new(container, record).data
      new_hash.delete('screenshot')
      Record::Base.new(container, record).data = new_hash
      Crawler::Slider.perform_async new_hash['url']
    end
  end
end
