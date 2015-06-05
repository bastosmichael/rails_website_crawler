class Syncer::Reslider < Syncer::Base
  def perform(container)
    @container = container
    records.with_progress("Reslide Crawling #{container}").each do |r|
      Crawler::Slider.perform_async record(r.key).url
    end
  end
end
