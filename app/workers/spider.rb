class Spider < Worker
  sidekiq_options backtrace: true, unique: :all, expiration: 24 * 60 * 60

  def perform url, params = nil, headers = ''
  	@url = url
    get_page params, headers
    parser.internal_links.each do |link|
      push_job link
    end
  end

  def get_page params = nil, headers = ''
    parser.page = params ? scraper.post(params, headers) : scraper.get
  end

  def scraper
  	@scraper ||= Scrape.new(@url)
  end

  def parser
  	@parser ||= Parse.new(@url)
  end

  def push_job link
    Spider.perform_async link if !crawled? link
  end

  def crawled? key
    in_vcr? key || in_sidekiq? key
  end  

  def in_sidekiq? key

  end

  def in_vcr? key
    Persist.instance.exists? Url.new(key).cache_key + '.yml'
  end
end