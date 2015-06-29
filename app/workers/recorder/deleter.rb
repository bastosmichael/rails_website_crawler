class Recorder::Deleter < Recorder::Base
  def perform(url)
    @name = Page::Url.new(url).name
    @container = Rails.configuration.config[:admin][:api_containers].find { |c| c.include?(@name) }
    @index = Rails.env + '-' + @container

    if record = Elasticsearch::Model.client.search(index: @index, type: @container, body: { query: { match_phrase_prefix: { url: url } } })
      Elasticsearch::Model.client.delete index: @index, type: @container, id: record['hits']['hits'].try(:first)['_id']
      cloud.head(record['hits']['hits'].try(:first)['_id'] + '.json').try(:destroy)
    end
  end
end
