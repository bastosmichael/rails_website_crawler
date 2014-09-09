class Uploader < Worker
  sidekiq_options queue: :uploader,
                  retry: true,
                  backtrace: true,
                  unique: true,
                  unique_job_expiration: 24 * 60 * 60

  def perform hash = {}
    require 'ap'
    ap hash
  end
end