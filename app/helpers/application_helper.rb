# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

 def include_stylesheets
   output = ""
   output << stylesheet_link_tag("default")
   if @navbar or File.exist?("app/views/#{controller.controller_name}/_navbar.rhtml")
     output << stylesheet_link_tag("menu")
   end
   output << stylesheet_link_tag(*@stylesheets) if @stylesheets
   return output
 end

 def include_navbar
  # (1) control if the variable @navbar exists
  return @navbar if @navbar 
  # (2) control if the partial _navbar exists
  if File.exist?("app/views/#{controller.controller_name}/_navbar.rhtml")
   return(render :partial => "navbar") 
  end
  # (3) if both don't exist display nothing
  return nil 
 end

end
