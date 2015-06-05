class Recorder::Uploader < Recorder::Base
  def perform(metadata = {})
    if url = metadata['url']
      uploader = Record::Upload.new(url)
      uploader.id = metadata['id']
      uploader.metadata = metadata
      hash = uploader.sync

      Mapper::Indexer.perform_async uploader.container,
                                     uploader.id,
                                     hash
    end unless metadata.nil?
  end
end
