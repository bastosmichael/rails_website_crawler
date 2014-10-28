class Recorder::Base < Worker
  def cloud
    @cloud ||= Cloud.new(@container)
  end

  def records
    @records ||= cloud.files
  end
end
