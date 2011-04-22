module FaceboxRenderHelper

  def facebox_link_to(name, options = {}, html_options = nil)  
    link_to_function(name, "jQuery.facebox(function(){ #{remote_function(options)} })", html_options || options.delete(:html))
  end

end