class Syncer::Respider < Syncer::Base
  def perform(container)
    @container = container
    records.with_progress("Respider Crawling #{container}").each do |r|
      Crawler::Spider.perform_async record(r.key).url
    end
  end
end
