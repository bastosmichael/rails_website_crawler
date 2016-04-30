class Recorder::Base < Worker
  sidekiq_options queue: :recorder,
                  retry: true,
                  backtrace: true
                  # unique: :until_and_while_executing,
                  # unique_expiration: 120 * 60

  def cloud
    @cloud ||= Cloud.new(@container)
  end
end
