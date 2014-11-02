class Recorder::Respider < Recorder::Base

  def perform container
    @container = container
    records.each do |r|
      Crawler::Spider.perform_async record(r.key).url
    end
  end
end
