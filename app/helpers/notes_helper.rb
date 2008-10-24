module NotesHelper
  
  def link_to_twitter(name)
    link_to name, "http://twitter.com/#{name}"
  end
  
  def message(msg)
    h(msg.gsub(/\+ *$/,''))
  end
  
end
