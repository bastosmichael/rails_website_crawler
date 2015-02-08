class Record::Base
  def initialize(container, record)
    @record = record
    @container = container
  end

  def delete
    cloud.head(@record).try(:destroy)
  end

  def url
    @url ||= data['url']
  end

  def screenshots
    @screenshots ||= data['screenshot'].map { |_key, value| { value => url } }.reduce({}, :merge)
  end

  def data
    JSON.parse(cloud.get(@record).try(:body), quirks_mode: true)
  rescue
    {}
  end

  def current_data
    old_data = data
    return { error: 'not available'} if old_data.nil?
    new_data = {}
    old_data.with_progress.each do |k, v|
      new_data[k] = v.is_a?(Hash) ? v.values.last : v
    end if old_data['id']
    new_data
  end

  def historical_data
    old_data = data
    return { error: 'not available'} if old_data.nil?
    new_data = { id: old_data['id'],
                 name: old_data['name']}
    old_data.with_progress.each do |k, v|
      new_data[k] = v if v.is_a?(Hash)
    end if old_data['id']
    new_data
  end

  def data=(new_hash = {})
    cloud.sync @record, new_hash.to_json
  end

  def cloud
    @cloud ||= Cloud.new(@container)
  end
end
