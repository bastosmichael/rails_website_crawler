class Page::Url
  URI_REGEX = /\A#{URI.regexp(%w(http https))}\z/

  attr_accessor :date

  def initialize(url)
    @url = clean_up_url(url)
    self.date = Date.today.to_s if date.nil?
  end

  def cache_key
    File.join(build_path, date)
  end

  def build_path
    File.join(host, md5)
  end

  def uri
    @uri ||= URI.parse(@url)
  end

  def url
    @url ||= uri.to_s
  end

  def md5
    Digest::MD5.hexdigest(url)
  end

  def host
    get_host_without_www uri
  end

  def name
    host.split('.').first
  end

  def get_host_without_www(new_uri)
    host = new_uri.host.downcase
    host.start_with?('www.') ? host[4..-1] : host
  end

  def clean_up_url(url)
    url = URI.encode(url)
    url = "http://#{url}" if URI.parse(url).scheme.nil?
    url
  end
end
