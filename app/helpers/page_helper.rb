module PageHelper
  def build_page
    self.methods.grep(/page_helper/).each do |page|
      self.send(page) 
    end
    # @id = @name.tr(" ", "_") if @type
  end

  def page_helper_id
    @id = md5 if !@id
  end

  def page_helper_url
    @url = parser.css("link[@rel='canonical']").first['href'].try(:squish) if !@url rescue nil
    @url = page.uri.to_s if !@url
  end

  def page_helper_name
    @name = parser.at('title').inner_html.try(:squish) if !@name rescue nil
  end

  def page_helper_description
    @description = parser.css("meta[@name='description']").first['content'].try(:squish) if !@description rescue nil
  end

  def page_helper_mobile_url
    @mobile_url = parser.css("link[@media='handheld']").first['href'].try(:squish) if !@mobile_url rescue nil
  end
end