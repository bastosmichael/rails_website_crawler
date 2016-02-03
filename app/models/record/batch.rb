class Record::Batch < Record::Base
  def batch(batch_hash = {}, options = { crawl: true, social: false, results: 10 })
    @options = options
    @batch_hash = batch_hash

    if batch_hash.values.flatten.count > options[:results]
      return { error: 'exceeded maximum number of ids: ' + options[:results] }
    else

    end
  end
end
