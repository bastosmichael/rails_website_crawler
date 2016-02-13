class Syncer::Resocializer < Syncer::Base
  def perform(container)
    @container = container
    records.with_progress("Resocialize Crawling #{container}").each do |r|
      Crawler::Socializer.perform_async record(r.key.gsub('.json','')).url
    end
  end
end
