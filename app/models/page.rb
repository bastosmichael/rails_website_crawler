class Page < Url
  attr_accessor :page

  def base
    "#{page.uri.scheme}://#{page.uri.host}"
  end
end