class Recorder::Rescreener < Recorder::Base

  def perform container, cleanup = false
    @container = container
    records.each do |r|
      record(r.key).screenshots.each do |key, value|
        unless files.include? key
          Crawler::Screener.perform_async value, key
        end
        files.delete(key)
      end
    end if screenshots_cloud
    files.each { |f| screenshots_cloud.head(f).try(:destroy) } if cleanup
  end

  def screenshots_container
    @screenshots_container ||= @container.match(/(.+)-/)[1] + '-screenshots' rescue nil
  end

  def screenshots_cloud
    @screenshots_cloud ||= Cloud.new(screenshots_container) rescue nil
  end

  def files
    @files ||= screenshots_cloud.files.map(&:key)
  end
end
