class Recorder::Uploader < Recorder::Base
  def perform(metadata = {})
    if url = metadata['url']
      uploader = Record::Upload.new(url)
      uploader.id = metadata['id']
      uploader.metadata = metadata
      new_data = {}

      uploader.sync.with_progress.each do |k, v|
        unless Record::Upload::EXCLUDE.include? k.to_sym
          new_data[k] = v.is_a?(Hash) ? v.values.last : v
          new_data[k + '_history'] = v.count if v.is_a?(Hash) && v.count > 1
        end
      end

      Mapper::Combiner.perform_async uploader.container,
                                     uploader.id,
                                     new_data
    end unless metadata.nil?
  end
end
