# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

 def include_navbar
  # (1) control if the variable @navbar exists
  return @navbar if @navbar
  # (2) control if the partial _navbar exists
  if File.exist?("app/views/#{controller.controller_name}/_navbar.html.erb")
   return(render :partial => "navbar")
  end
  # XXX: remove this hack
  if File.exist?("../app/views/#{controller.controller_name}/_navbar.html.erb")
   return(render :partial => "navbar")
  end
  # (3) if both don't exist display nothing
  return nil
 end

end
