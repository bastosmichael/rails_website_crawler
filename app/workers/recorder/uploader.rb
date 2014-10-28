class Recorder::Uploader < Recorder::Base

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
