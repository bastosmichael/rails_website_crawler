class Syncer::Resampler < Syncer::Base
  def perform(container, sampler_type = 'Sampler', scrimper_type = 'Scrimper')
    @container = container
    records.with_progress("Resample Crawling #{container}").each do |r|
      ('Crawler::' + sampler_type).constantize.perform_async record(r.key).url, scrimper_type
    end
  end
end
