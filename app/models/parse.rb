class Parse < Page
  include PageHelper
  include OpenGraphHelper
  include SchemaOrgHelper

  def build
  	parent_build
  end

  def parent_build
  	build_page
  	build_open_graph
  	build_schema
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
