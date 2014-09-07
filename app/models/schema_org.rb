class SchemaOrg < Page

  def id
    @id = Digest::MD5.hexdigest(page.uri.to_s) if !@id
  end

  def new_url
    @url = parser.css("link[@rel='canonical']").first['href'] if !@url rescue nil
    @url = page.uri.to_s if !@url
  end

  def new_name
    @name = parser.at('title').inner_html if !@name rescue nil
  end

  def description
    @description = parser.css("meta[@name='description']").first['content'] if !@description rescue nil
  end

  def mobile_url
    @mobile_url = parser.css("link[@media='handheld']").first['href'] if !@mobile_url rescue nil
  end

  ###############################################################
  # Types that have multiple parents are expanded out only once 
  # and have an asterisk 
  ###############################################################

  def schema_type
    @type = page.body.match(/itemtype="http:\/\/schema.org\/(.+?)"/)[1]
  end

  ###############################################################
  # Grab Meta Data for Schema and assign instance variable
  ###############################################################

  def schema_meta
    parser.css('//meta').each do |m|
    if !m[:itemprop].nil?
      instance_variable_set("@#{m[:itemprop].tr(" ", "_")}","#{m[:content]}")
    end
    end
  end

  ###############################################################
  # Grab Span Data for Schema and assign instance variable
  ###############################################################

  def schema_span
    parser.css('//span').each do |m|
    if !m[:itemprop].nil?
      instance_variable_set("@#{m[:itemprop].tr(" ", "_")}","#{m.text}")
    end
    end
  end

  ###############################################################
  # Grabbing Keywords as Tags
  ###############################################################

  def schema_tags
    tags = parser.css("meta[@name='keywords']").first['content'].split(/ |,/)
    tags.delete_if {|x| x.match(/and|for|more/)}
    @tags = tags.reject(&:empty?).uniq
  end
end
