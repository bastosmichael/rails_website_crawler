class Page < Url
  attr_accessor :page

  def parser
    page.parser
  end

  def base
    "#{page.uri.scheme}://#{page.uri.host}"
  end

  def parent_build
    self.methods.grep(/page/).each do |og|
      self.send(og) 
    end
    # @id = @name.tr(" ", "_") if @type
  end

  def page_id
    @id = Digest::MD5.hexdigest(page.uri.to_s) if !@id
  end

  def page_url
    @url = parser.css("link[@rel='canonical']").first['href'] if !@url rescue nil
    @url = page.uri.to_s if !@url
  end

  def page_name
    @name = parser.at('title').inner_html if !@name rescue nil
  end

  def page_description
    @description = parser.css("meta[@name='description']").first['content'] if !@description rescue nil
  end

  def page_mobile_url
    @mobile_url = parser.css("link[@media='handheld']").first['href'] if !@mobile_url rescue nil
  end

  def save
    remove_instance_variable(:@page)
    hash = {}
    instance_variables.each do |var| 
      hash[var.to_s.delete("@")] = instance_variable_get(var) 
    end
    hash
  end
end