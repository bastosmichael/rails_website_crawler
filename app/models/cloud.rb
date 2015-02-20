class Cloud
  MAX_KEYS = 100_000_000_000

  attr_accessor :bucket
  attr_accessor :provider

  def initialize(bucket_name)
    self.bucket = bucket_name if bucket_name
  end

  def after_initialize
    return unless new_record?
    self.bucket = 'crawler'
  end

  def storage
    @storage ||= Fog::Storage.new(Rails.configuration.config['fog'].symbolize_keys!)
  end

  def container
    @container ||= storage.directories.get(bucket)
    create_container if @container.nil?
    @container
  end

  def files
    @files ||= update_files
  end

  def keys
    @keys ||= files.map(&:key)
  end

  def update_files
    files = container.files
    truncated = files.try(:is_truncated)
    while truncated
      bucket_object = container.files.all(marker: files.last.key)
      truncated = bucket_object.is_truncated
      files = files + bucket_object
    end
    files
  end

  def listing(prefix)
    @listing ||= container.files.all delimiter: '/', prefix: prefix
  end

  def head(key)
    container.files.head key
  end

  def get(key)
    container.files.get key
  end

  def get_url(key)
    container.files.get_https_url(key, 300)
  end

  def sync(key, data)
    if data
      copy key, data
    else
      head = head key
      head.try :destroy
    end
  end

  def copy(key, data)
    file = container.files.new key: key
    file.body = data
    file.save
  end

  def create_container
    @container = storage.directories.create(key: bucket, public: true)
  end

  def delete_all
    files.with_progress.each { |k| k.try(:destroy) }
  end

  def count
    files.count
  end
end
