class Recorder::Retreader < Recorder::Base
  sidekiq_options queue: :retreader,
                  retry: true,
                  backtrace: true,
                  unique: true,
                  unique_job_expiration: 24 * 60 * 60

  def perform container
    @container = container
    records.each do |r|
      Crawler::Scrimper.perform_async record(r.key).url
    end
  end

  def record record
    Record.new(@container, record)
  end
end
