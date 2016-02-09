class Crawl::Capture < Page::Url
  require 'mini_magick'
  # require 'rmagick'
  # include Magick

  attr_accessor :relative_path

  # PNG = '.png'
  JPG = '.jpg'

  def screening
    temp_file.write(download)
    temp_file.flush

    image = MiniMagick::Image.new(temp_path)
    image.crop "1024x1024+8+8"
    image.strip
    image.quality "80"
    image.depth "8"
    image.interlace "plane"

  end

  def download
    IMGKit.new(@url).to_jpg
  end

  def temp_file
    @temp_file ||= Tempfile.new([md5, JPG], 'tmp', :encoding => 'ascii-8bit')
  end

  def temp_path
    @temp_path ||= Rails.root.join(temp_file.path)
  end

  # def screen
  #   unless cloud.head relative_path
  #     check_temp_path
  #     get_png
  #     compress_png
  #     cloud.sync(relative_path, jpeg)
  #     delete_images
  #   end
  #   relative_path
  # end

  # def compress_png
  #   image.minify.write(jpg_file_path) do
  #     self.format = 'JPEG'
  #   end
  # end

  # def get_png
  #   headless = Headless.new
  #   headless.start
  #   driver = Selenium::WebDriver.for :firefox
  #   driver.navigate.to @url
  #   driver.save_screenshot(png_file_path)
  #   driver.close
  #   headless.destroy
  # end

  # def check_temp_path
  #   path = File.dirname temp_path
  #   FileUtils.mkdir_p(path) unless File.exist?(path)
  # end

  # def delete_images
  #   FileUtils.rm jpg_file_path
  #   FileUtils.rm png_file_path
  # rescue Errno::ENOENT
  #   nil
  # end

  # def jpeg
  #   File.read jpg_file_path
  # rescue Errno::ENOENT
  #   nil
  # end

  # def png_file_path
  #   temp_path + PNG
  # end

  # def jpg_file_path
  #   temp_path + JPG
  # end

  # def temp_path
  #   File.join(Rails.root, 'tmp/cache', md5)
  # end

  # def image
  #   @image ||= Image.read(png_file_path).first
  # end

  # def cloud
  #   @cloud ||= Cloud.new(name + '-screenshots')
  # end
end
