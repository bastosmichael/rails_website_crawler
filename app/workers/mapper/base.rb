class Mapper::Base < Worker
  sidekiq_options queue: :mapper,
                  retry: true,
                  backtrace: true,
                  unique: :until_and_while_executing,
                  unique_expiration: 120 * 60

  def cloud
    @cloud ||= Cloud.new(@container)
  end

  def records
    @records ||= cloud.files.select { |f| f unless f.key.starts_with? '_' }
  end

  def indexes
    @records ||= cloud.files.select { |f| f if f.key.starts_with? '_' }
  end

  def record(record)
    Record::Base.new(@container, record)
  end
end
