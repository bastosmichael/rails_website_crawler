class Crawl::Capture < Page::Url
  require 'rmagick'
  include Magick

  attr_accessor :relative_path

  PNG = '.png'
  JPG = '.jpg'

  def screen
    unless cloud.head relative_path
      check_temp_path
      get_png
      compress_png
      cloud.sync(relative_path, jpeg)
      delete_images
    end
    relative_path
  end

  def compress_png
    image.minify.write(jpg_file_path) do
      self.format = 'JPEG'
    end
  end

  def get_png
    headless = Headless.new
    headless.start
    driver = Selenium::WebDriver.for :firefox
    driver.navigate.to @url
    driver.save_screenshot(png_file_path)
    driver.close
    headless.destroy
  end

  def check_temp_path
    path = File.dirname temp_path
    FileUtils.mkdir_p(path) unless File.exist?(path)
  end

  def delete_images
    FileUtils.rm jpg_file_path
    FileUtils.rm png_file_path
  rescue Errno::ENOENT
    nil
  end

  def jpeg
    File.read jpg_file_path
  rescue Errno::ENOENT
    nil
  end

  def png_file_path
    temp_path + PNG
  end

  def jpg_file_path
    temp_path + JPG
  end

  def temp_path
    File.join(Rails.root, 'tmp/cache', md5)
  end

  def image
    @image ||= Image.read(png_file_path).first
  end

  def cloud
    @cloud ||= Cloud.new(name + '-screenshots')
  end
end
