class Cloud
  include Singleton
  
  CONTAINER = 'crawler'

  def storage
    @storage = Fog::Storage.new({ provider: 'Local',
                                  local_root:'tmp/fog',
                                  endpoint: 'http://example.com' })
  end

  def container
    @container = storage.directories.get(CONTAINER)
    create_container if @container.nil?
    return @container
  end

  def files
    @files = container.files
  end

  def listing prefix
    files.all delimiter: '/', prefix: prefix
  end

  def head key
    files.head key
  end

  def get key
    files.get key
  end

  def sync key, data
    if data
      copy key, data
    else
      head = head key
      head.try :destroy
    end
  end

  def copy key, data
    file = files.new key: key
    file.body = data
    file.save
  end

  def create_container
    storage.directories.create({ :key => CONTAINER, :public => true })
  end
end