class Cloud
  attr_accessor :bucket
  attr_accessor :provider

  def initialize bucket_name
    self.bucket = bucket_name if bucket_name
  end

  def after_initialize
     return unless new_record?
     self.bucket = 'crawler'
  end

  def storage
    @storage = Fog::Storage.new(SETTINGS[:fog])
  end

  def container
    @container = storage.directories.get(bucket) 
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
    @container = storage.directories.create({ :key => bucket, :public => true })
  end
end