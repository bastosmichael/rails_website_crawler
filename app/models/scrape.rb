class Scrape
  def initialize url
    @url = clean_up_url(url)
  end

  def mechanize
  	@mechanize ||= defaults
  end

  def page
    mechanize.page
  end

  def cache_key
    File.join(build_path, Date.today.to_s)
  end

  def build_path
    File.join(name, host, md5)
  end

  def uri
    @uri ||= get_uri
  end

  def url
    uri.to_s
  end

  def md5
    Digest::MD5.hexdigest(url)
  end

  def host
    get_host_without_www
  end

  def name
    host.split('.').first
  end

  def get
  	Timeout.timeout(60) do 
      VCR.use_cassette(cache_key) do
  	    mechanize.get(url)
      end
  	end
  end

  def post params, headers = ''
  	Timeout.timeout(60) do 
      VCR.use_cassette(File.join(cache_key, params.to_query + headers) do
  	    mechanize.post(url, params, headers)
      end
  	end
  end

  private

  def get_uri
    page ? page.uri : URI.parse(@url)
  end

  def get_host_without_www
    host = uri.host.downcase
    host.start_with?('www.') ? host[4..-1] : host
  end

  def clean_up_url url
    url = URI.encode(url)
    url = "http://#{url}" if URI.parse(url).scheme.nil?
    url
  end

  def defaults
    agent = Mechanize.new
    agent.user_agent = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36'
    agent.html_parser = Nokogiri::HTML
    agent.ssl_version = 'SSLv3'
    agent.open_timeout = 300
    agent.read_timeout = 300
    agent.idle_timeout = 300
    agent.max_history = 10
    agent.keep_alive = true
    agent
  end
end
