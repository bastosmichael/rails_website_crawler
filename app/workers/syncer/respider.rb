class Syncer::Respider < Syncer::Base
  def perform(container, spider_type = 'Scrimper')
    @container = container
    records.with_progress("Respider Crawling #{container}").each do |r|
      ('Crawler::' + spider_type).constantize.perform_async record(r.key).url
    end
  end
end
