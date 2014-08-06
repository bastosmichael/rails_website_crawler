class Persister
  def [](key)
    Cloud.instance.get(key).try(:body)
  end

  def []=(key, content)
    Cloud.instance.sync(key, content)
  end
end