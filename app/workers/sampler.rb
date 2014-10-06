class Sampler < Creeper
  sidekiq_options queue: :sampler,
                  retry: true,
                  backtrace: true,
                  unique: true,
                  unique_job_expiration: 24 * 60 * 60

  def perform url
    @url = url
    parser.page = scraper.get
    Uploader.perform_async parsed if exists?
    visit.sample
  rescue Net::HTTP::Persistent::Error
    Sampler.perform_async @url
  end

  def visit
    @visit ||= Visit.new(parser.internal_links)
  end
end
