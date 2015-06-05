class Syncer::Resampler < Syncer::Base
  def perform(container)
    @container = container
    records.with_progress("Resample Crawling #{container}").each do |r|
      Crawler::Sampler.perform_async record(r.key).url
    end
  end
end
