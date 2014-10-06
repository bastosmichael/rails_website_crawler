class Scrimper < Creeper
  sidekiq_options queue: :scrimper,
                  retry: true,
                  backtrace: true,
                  unique: true,
                  unique_job_expiration: 24 * 60 * 60

  def perform url
    @url = url
    parser.page = scraper.get
    Uploader.perform_async parsed if exists?
  rescue Net::HTTP::Persistent::Error
    Scrimper.perform_async @url
  end
end
