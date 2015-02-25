class Record::Screenshot < Record::Base
  def initialize(container, record, date)
    if match = container.match(/(.+?)-/)
      @container = match[1] + '-screenshots'
    end
    @record_id = record
    @record = record + '/' + date + '.jpg'
  end

  def screenshot
    @screenshot ||= cloud.get(@record)
  end

  def link
    screenshot.url(Date.tomorrow.to_time.to_i)
  end

  def data
    if screenshot
      {id: @record_id, redirect_url: link}
    else
      {error: 'screenshot not available'}
    end
  end
end
