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
    @storage ||= Fog::Storage.new(SETTINGS[:fog])
  end

  def container
    @container = storage.get_bucket(bucket, {'max-keys' =>'100000'} )
  rescue Excon::Errors::Forbidden
    return create_container
  end

  def files
    @files = update_files
  end

  def update_files
    truncated_files = container
    truncated = truncated_files.body['IsTruncated']
    @files = truncated_files.body['Contents']
    while truncated
      truncated_files = storage.get_bucket(bucket,{'max-keys' =>'100000', 'marker' => truncated_files.body['Contents'].last["Key"]})
      truncated = truncated_files.body['IsTruncated']
      @files = @files + truncated_files.body['Contents']
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
