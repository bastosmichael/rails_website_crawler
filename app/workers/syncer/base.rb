class Syncer::Base < Worker
  sidekiq_options queue: :syncer,
                  retry: true,
                  backtrace: true,
                  unique: true,
                  unique_job_expiration: 24 * 60 * 60

  def cloud
    @cloud ||= Cloud.new(@container)
  end

  def records
    @records ||= cloud.files.map { |f| f unless f.key.starts_with? '_' }.compact
  end

  def record(record)
    Record::Base.new(@container, record)
  end
end
