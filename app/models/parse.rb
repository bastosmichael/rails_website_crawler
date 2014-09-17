class Parse < Page
  include PageHelper
  include OpenGraphHelper
  include SchemaOrgHelper

  def build
    parent_build
    self.methods.grep(/find_/).each { |parse| self.send(parse) } if @type
  end

  def parent_build
    build_open_graph
    build_schema
    build_page
  end

  def screenshot
    @screenshot ||= File.join(host, md5, date) + '.jpg'
  end

  def save
    remove_instance_variable(:@page)
    remove_instance_variable(:@uri) rescue nil
    hash = {}
    instance_variables.each do |var|
      value = instance_variable_get(var)
      hash[var.to_s.delete("@")] = value if !value.blank?
    end
    hash
  end
end
