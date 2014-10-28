class Recorder::Uploader < Recorder::Base
  sidekiq_options queue: :uploader,
                  retry: true,
                  backtrace: true,
                  unique: true,
                  unique_job_expiration: 24 * 60 * 60

  def perform metadata = {}
    if @url = metadata['url']
      uploader.id = metadata['id']
      uploader.metadata = metadata
      uploader.sync
    end
  end

  def uploader
  	@uploader ||= Record::Upload.new(@url)
  end
end
