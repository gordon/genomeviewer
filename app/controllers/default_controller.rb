class DefaultController < ApplicationController
  
  def index
    @sidemenu = render_to_string :partial => "sidemenu"
  end
  
end
