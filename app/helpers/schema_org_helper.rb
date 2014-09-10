module SchemaOrgHelper

  def build_schema
    # schema = @page.doc.css('//*[contains(@itemtype, "schema.org")]').first["itemtype"]
    @schema_org = false
    self.methods.grep(/schema_org/).each do |schema|
      self.send(schema) rescue nil
    end
    @schema_org = true if @type
  end

  ###############################################################
  # Types that have multiple parents are expanded out only once 
  # and have an asterisk 
  ###############################################################

  def schema_org_type
    @type = page.body.match(/itemtype="http:\/\/schema.org\/(.+?)"/)[1].try(:squish)
  end

  ###############################################################
  # Grab Meta Data for Schema and assign instance variable
  ###############################################################

  def schema_org_meta
    parser.css('//meta').each do |m|
      if !m[:itemprop].nil?
        instance_variable_set("@#{m[:itemprop].tr(" ", "_")}","#{m[:content].try(:squish)}")
      end
    end
  end

  ###############################################################
  # Grab Span Data for Schema and assign instance variable
  ###############################################################

  def schema_org_span
    parser.css('//span').each do |m|
    if !m[:itemprop].nil?
      instance_variable_set("@#{m[:itemprop].tr(" ", "_")}","#{m.text.try(:squish)}")
    end
    end
  end

  ###############################################################
  # Grabbing Keywords as Tags
  ###############################################################

  def schema_org_tags
    tags = parser.css("meta[@name='keywords']").first['content'].split(/ |,/)
    tags.delete_if {|x| x.match(/and|for|more/)}
    @tags = tags.reject(&:empty?).uniq
  end
end
