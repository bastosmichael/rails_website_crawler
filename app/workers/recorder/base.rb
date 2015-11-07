class Recorder::Base < Worker
  sidekiq_options queue: :recorder,
                  retry: true,
                  backtrace: true,
                  unique: :until_executed

  def cloud
    @cloud ||= Cloud.new(@container)
  end
end
