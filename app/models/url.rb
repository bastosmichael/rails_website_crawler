class Url
  def initialize url
  	@url = clean_up_url(url)
  end

  def address
    uri.to_s
  end

  def md5
    Digest::MD5.hexdigest(address)
  end

  def uri
  	@uri ||= URI.parse(@url)
  end

  def host
  	get_host_without_www
  end

  def name
  	host.split('.').first
  end

  private

  def get_host_without_www
    host = uri.host.downcase
    host.start_with?('www.') ? host[4..-1] : host
  end

  def clean_up_url url
  	url = URI.encode(url)
  	url = "http://#{url}" if URI.parse(url).scheme.nil?
  	url
  end
end