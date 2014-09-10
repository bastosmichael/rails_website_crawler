class Uploader < Worker
  sidekiq_options queue: :uploader,
                  retry: true,
                  backtrace: true,
                  unique: true,
                  unique_job_expiration: 24 * 60 * 60

  def perform metadata = {}
    if @url = metadata['url']
      resoluter.metadata = metadata
      resoluter.sync
    end
  end

  def resoluter
  	@resoluter ||= Results.new(@url) 
  end
end