class Syncer::Base < Worker
  sidekiq_options queue: :syncer,
                  retry: true,
                  backtrace: true,
                  unique: :until_executed

  def cloud
    @cloud ||= Cloud.new(@container)
  end

  def records
    @records ||= cloud.files
  end

  def record(record)
    Record::Base.new(@container, record)
  end
end
