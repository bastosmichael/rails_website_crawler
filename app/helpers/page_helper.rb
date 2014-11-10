module PageHelper
  def build_page
    methods.grep(/page_helper/).each do |page|
      send(page)
    end
    # @id = @name.tr(" ", "_") if @type
  end

  def page_helper_id
    @id = md5 unless @id
  end

  def page_helper_url
    @url = parser.css("link[@rel='canonical']").first['href'].try(:squish) unless @url rescue nil
    @url = page.uri.to_s unless @url
  end

  def page_helper_name
    @name = parser.at('title').inner_html.try(:squish) unless @name rescue nil
  end

  def page_helper_description
    @description = parser.css("meta[@name='description']").first['content'].try(:squish) unless @description rescue nil
  end

  def page_helper_mobile_url
    @mobile_url = parser.css("link[@media='handheld']").first['href'].try(:squish) unless @mobile_url rescue nil
  end
end
