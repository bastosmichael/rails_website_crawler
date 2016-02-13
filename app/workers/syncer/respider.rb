class Syncer::Respider < Syncer::Base
  def perform(container, spider_type = 'Spider')
    @container = container
    records.with_progress("Respider Crawling #{container}").each do |r|
      ('Crawler::' + spider_type).constantize.perform_async record(r.key.gsub('.json','')).url
    end
  end
end
