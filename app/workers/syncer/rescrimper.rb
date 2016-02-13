class Syncer::Rescrimper < Syncer::Base
  def perform(container, scrimper_type = 'Scrimper')
    @container = container
    records.with_progress("Rescrimp Crawling #{container}").each do |r|
      ('Crawler::' + scrimper_type).constantize.perform_async record(r.key.gsub('.json','')).try(:url)
    end
  end
end
