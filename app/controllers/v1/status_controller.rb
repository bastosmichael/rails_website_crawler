class V1::StatusController < V1::AccessController
  def index
    respond_to do |format|
      format.json { json_response(200, api_data.merge(counts)) }
      format.xml { xml_response(200, api_data.merge(counts)) }
    end
  end

  private

  def counts
    { available: count_indexes,
      indexing: pretty_integer(count_indexers),
      processing: pretty_integer(count_scrimpers),
      pending: pretty_integer(count_sitemappers * 50_000) }
  end

  def count_indexes
    Rails.configuration.config[:admin][:api_containers]
      .map { |c| [c, count_containers(c)] }
      .sort_by(&:last).reverse
      .map { |array| { array.first => pretty_integer(array.last) } }.inject(:merge)
  end

  def count_indexers
    Sidekiq::Queue.new('mapper').size +
      Sidekiq::Queue.new('recorder').size
  rescue Redis::CannotConnectError => e
    0
  end

  def count_scrimpers
    Sidekiq::Queue.new('scrimper').size +
      Sidekiq::Queue.new('scrimper_one').size +
      Sidekiq::Queue.new('scrimper_two').size +
      Sidekiq::Queue.new('scrimper_three').size +
      Sidekiq::Queue.new('scrimper_four').size +
      Sidekiq::Queue.new('scrimper_five').size +
      Sidekiq::Queue.new('sampler').size +
      Sidekiq::Queue.new('sampler_one').size +
      Sidekiq::Queue.new('sampler_two').size +
      Sidekiq::Queue.new('sampler_three').size +
      Sidekiq::Queue.new('sampler_four').size +
      Sidekiq::Queue.new('sampler_five').size +
      Sidekiq::Queue.new('spider').size +
      Sidekiq::Queue.new('spider_one').size +
      Sidekiq::Queue.new('spider_two').size +
      Sidekiq::Queue.new('spider_three').size +
      Sidekiq::Queue.new('spider_four').size +
      Sidekiq::Queue.new('spider_five').size +
      Sidekiq::Queue.new('slider').size +
      Sidekiq::Queue.new('socializer').size
  rescue Redis::CannotConnectError => e
    0
  end

  def count_sitemappers
    Sidekiq::Queue.new('sitemapper').size +
      Sidekiq::Queue.new('sitemapper_one').size +
      Sidekiq::Queue.new('sitemapper_two').size +
      Sidekiq::Queue.new('sitemapper_three').size +
      Sidekiq::Queue.new('sitemapper_four').size +
      Sidekiq::Queue.new('sitemapper_five').size
  rescue Redis::CannotConnectError => e
    0
  end

  def count_containers(container)
    index = Rails.env + '-' + container.split('-').last.pluralize.delete(':')
    Elasticsearch::Model.client.count(index: index, type: container)['count']
  rescue Elasticsearch::Transport::Transport::Errors => e
    0
  end
end
