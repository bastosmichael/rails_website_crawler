class Scrape < Url

  def agent
  	@agent ||= defaults
  end

  def page
    agent.page
  end

  def get
  	Timeout.timeout(60) do 
      # TODO change it back to cache_key when built
      VCR.use_cassette(build_path) do
  	    agent.get(url)
      end
  	end
  end

  def post params, headers = ''
  	Timeout.timeout(60) do 
      VCR.use_cassette(File.join(cache_key, params.to_query + headers)) do
  	    agent.post(url, params, headers)
      end
  	end
  end

  private

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
