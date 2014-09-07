class Page < Url
  attr_accessor :page

  def parser
    page.parser
  end

  def base
    "#{page.uri.scheme}://#{page.uri.host}"
  end
end