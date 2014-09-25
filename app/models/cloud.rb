class Cloud
  MAX_KEYS = 100000000000

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
    @storage ||= Fog::Storage.new(SETTINGS[:fog])
  end

  def container
    @container = storage.directories.get(bucket)
  rescue Excon::Errors::Forbidden
    return create_container
  end

  def files
    @files = update_files
  end

  def update_files
    @files = container.files.all({'max-keys' => MAX_KEYS })
    truncated = @files.is_truncated
    while truncated
      bucket_object = container.files.all({'max-keys' => MAX_KEYS, 'marker' => @files.last.key })
      truncated = bucket_object.is_truncated
      @files = @files + bucket_object
    end
    @files
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
