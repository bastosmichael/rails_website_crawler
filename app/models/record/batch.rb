class Record::Batch < Record::Base
  MAX_BATCH = 50

  def batch(batch_hash = {}, options = { crawl: true, social: false, history: false, results: 10 })
    @options = options
    @batch_hash = batch_hash

    if batch_hash.values.flatten.count > MAX_BATCH
      return { error: 'exceeded maximum number of ids: ' + MAX_BATCH }
    else
      batch_hash.with_progress.map do |key, value|
        @container = key
        if value.kind_of?(Array)
          value.map do |id|
            @record = id
            if options[:history]
              historical_data(options)
            else
              current_data(options)
            end
          end
        else
          return { error: 'ids must be given as an array' }
        end
      end.flatten
    end
  end
end
