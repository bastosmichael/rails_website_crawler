class Persist
  def initialize cloud
    @cloud = cloud
  end

  def [](key)
    @cloud.get(key).try(:body)
  end

  def []=(key, content)
    @cloud.sync(key, content)
  end

  def exists? key
    @cloud.head(key)
  end
end
