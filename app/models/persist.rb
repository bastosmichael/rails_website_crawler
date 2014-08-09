class Persist
  def initialize(name)
  	@name = name
  end

  def [](key)
    Cloud.new(@name).get(key).try(:body)
  end

  def []=(key, content)
    Cloud.new(@name).sync(key, content)
  end
end