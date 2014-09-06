class Results < Page
  def cloud
    @cloud ||= Cloud.new(name + '_results')
  end
end