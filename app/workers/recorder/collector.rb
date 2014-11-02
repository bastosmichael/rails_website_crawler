class Recorder::Collector < Recorder::Base

  def perform container
    @container = container
    # collections.each do |r|
    #   ap record(r.key)
    # end
  end

  def collections
    @collections ||= cloud.files.map {|f| f if f.key.starts_with? '_' }.compact
  end
end
