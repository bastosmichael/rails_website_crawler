class Crawl::Base < Page::Url
  require 'user_agent_randomizer'
  require 'timeout'

  def agent
    @agent ||= defaults
  end

  def get
    page = agent.get(url)

    return page if page.code == '200'

    if page.code == '301' || page.code == '302'
      page = agent.get(url.gsub('http://','https://'))

      return page if page.code == '200'
    end

    raise Mechanize::ResponseCodeError.new(page, 'Not 200')
  end

  def clear
    agent.shutdown
  end

  def post(params, headers = '')
    # TODO: change it back to cache_key when built
    VCR.use_cassette(File.join(cache_vcr, params.to_query + headers), record: :new_episodes) do
      # Rails.cache.fetch(build_path, params.to_query + headers) do
      @agent = defaults
      @agent.post(url, params, headers)
    end
  end

  private

  def get_with_vcr(record)
    # TODO: change it back to cache_key when built
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
    agent.user_agent = UserAgentRandomizer::UserAgent.fetch(type: "desktop_browser").string
    agent.html_parser = Nokogiri::HTML
    agent.redirect_ok = false
    # agent.ssl_version = 'SSLv3'
    # agent.open_timeout = 300
    # agent.read_timeout = 300
    # agent.idle_timeout = 300
    # agent.max_history = 10
    agent.keep_alive = false
    agent
  end
end
