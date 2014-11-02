class Recorder::Resampler < Recorder::Base

  def perform container
    @container = container
    records.each do |r|
      Crawler::Sampler.perform_async record(r.key).url
    end
  end
end
