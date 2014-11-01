class Recorder::Retreader < Recorder::Base

  def perform container
    @container = container
    records.each do |r|
      Crawler::Scrimper.perform_async record(r.key).url
    end
  end
end
