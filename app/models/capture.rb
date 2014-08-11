class Capture < Url
  require 'RMagick'
  include Magick

  def screen
  	if !File.exist?(png_file_path)
      check_temp_path
      get_png
      compress_png
    end
  end

  def compress_png
    image.write(jpg_file_path) do
      self.format = 'JPEG'
      self.quality = 10
    end
  end

  def get_png
    Headless.ly do
      driver = Selenium::WebDriver.for :firefox
      driver.navigate.to @url
      driver.save_screenshot(png_file_path)
    end
  end

  def check_temp_path
    path = File.dirname temp_path
    FileUtils::mkdir_p(path) if !File.exist?(path)
  end

  def png_file_path
    temp_path + '.png'
  end

  def jpg_file_path
    temp_path + '.jpg'
  end

  def temp_path
  	File.join(Rails.root, 'tmp/screenshots', cache_key)
  end

  def image
    @image ||= Image.read(png_file_path).first
  end
end
