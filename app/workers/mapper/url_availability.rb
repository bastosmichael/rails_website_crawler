class Mapper::UrlAvailability < Mapper::Base
  def perform(url)
    @name = Page::Url.new(url).name
    @container = Rails.configuration.config[:admin][:api_containers].find { |c| c.include?(@name) }
    types = @container.split('-').last.pluralize.gsub(':', '')
    @index = Rails.env + '-' + types

    records = Elasticsearch::Model.client.search(index: @index, type: @container, body: { query: { match_phrase_prefix: { url: url } } })

    if records['hits']['total'] > 0
      records['hits']['hits'].each do |record|
        Recorder::Uploader.perform_async({ id: record['_id'],
                                           available: false,
                                           url: record['_source']['url'],
                                           type: record['_type'].split('-').last.capitalize.singularize })
        # cloud.head(record['_id'] + '.json').try(:destroy)
        # Elasticsearch::Model.client.delete index: @index, type: @container, id: record['_id']
        # Crawler::Scrimper.perform_async url
      end
    end
  # rescue NoMethodError => e
  #   nil
  end
end
