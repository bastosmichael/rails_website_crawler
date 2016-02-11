class Crawl::Capture < Page::Url
  require 'mini_magick'

  attr_accessor :relative_path

  JPG = '.jpg'

  def screen
    temp_file.write(download)
    temp_file.flush

    image = MiniMagick::Image.new(temp_path)
    image.crop "1024x1024+8+8"
    image.strip
    image.quality "80"
    image.depth "8"
    image.interlace "plane"

    cloud.sync(relative_path, jpeg)
    temp_file.unlink

    relative_path
  end

  def download
    IMGKit.new(uri.to_s).to_jpg
  end

  def temp_file
    @temp_file ||= Tempfile.new([md5, JPG], 'tmp', :encoding => 'ascii-8bit')
  end

  def temp_path
    @temp_path ||= Rails.root.join(temp_file.path)
  end

  def jpeg
    File.read temp_path
  rescue Errno::ENOENT
    nil
  end

  def delete_images
    FileUtils.rm temp_path
  rescue Errno::ENOENT
    nil
  end

  def cloud
    @cloud ||= Cloud.new(name + '-screenshots')
  end
end
