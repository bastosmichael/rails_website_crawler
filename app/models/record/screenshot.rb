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

  def json
    if screenshot
      {id: @record_id, screenshot_url: link}.to_json
    else
      {error: 'screenshot not available'}.to_json
    end
  end
end
