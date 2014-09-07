class Page
  attr_accessor :page

  def parser
    page.parser
  end

  def base
    "#{page.uri.scheme}://#{page.uri.host}"
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