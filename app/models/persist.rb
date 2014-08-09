class Persist
  def initialize(name)
  	@name = name
  end

  def cloud
  	@cloud ||= Cloud.new(@name)
  end

  def [](key)
    cloud.get(key).try(:body)
  end

  def []=(key, content)
    cloud.sync(key, content)
  end
end