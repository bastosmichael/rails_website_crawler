class Spider < Worker
  sidekiq_options :queue => :spider, :backtrace => true, :retry => true

  def perform url
  	@url = url


  	
  end

  def url_handler
  	@url_handler ||= Url.new(@url)
  end
end