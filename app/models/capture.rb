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
    image.write(png_file_path) do 
      self.compression = Magick::ZipCompression
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
    FileUtils::mkdir_p(temp_path) if !File.exist?(temp_path)
  end

  def png_file_path
    File.join(temp_path, date + '.png')
  end

  def temp_path
  	File.join(Rails.root, 'tmp/screenshots', build_path)
  end

  def image
    @image ||= Image.read(png_file_path).first
  end
end