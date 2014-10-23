class Record
  def initialize container, record
    @record = record
    @container = container
  end

  def url
    @url ||= data['url']
  end

  def screenshots
    @screenshots ||= data['screenshot'].map {|key, value| { value => url } }
  end

  def data
    JSON.parse(cloud.get(@record).try(:body), :quirks_mode => true)
  rescue
    {}
  end

  def data= new_hash = {}
    cloud.sync @record, new_hash.to_json
  end

  def cloud
    @cloud ||= Cloud.new(@container)
  end
end
