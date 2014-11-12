class Recorder::Recrimper < Recorder::Base
  def perform(container)
    @container = container
    records.with_progress.each do |r|
      Crawler::Scrimper.perform_async record(r.key).url
    end
  end
end
