class Crawl::Base < Page::Url
  def agent
    @agent ||= defaults
  end

  def get
    # 	get_with_vcr :new_episodes
    # rescue Psych::SyntaxError
    agent.get(url)
  end

  def post(params, headers = '')
    # TODO change it back to cache_key when built
    VCR.use_cassette(File.join(cache_vcr, params.to_query + headers), record: :new_episodes) do
      # Rails.cache.fetch(build_path, params.to_query + headers) do
      @agent = defaults
      @agent.post(url, params, headers)
    end
  end

  private

  def get_with_vcr(record)
    # TODO change it back to cache_key when built
    VCR.use_cassette(cache_vcr, record: record) do
      # Rails.cache.fetch(build_path) do
      @agent = defaults
      @agent.get(url)
    end
  end

  def cache_vcr
    File.join(host, date, md5)
  end

  def defaults
    agent = Mechanize.new
    agent.user_agent = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36'
    agent.html_parser = Nokogiri::HTML
    # agent.ssl_version = 'SSLv3'
    agent.open_timeout = 300
    agent.read_timeout = 300
    agent.idle_timeout = 300
    agent.max_history = 10
    agent.keep_alive = true
    agent
  end
end
