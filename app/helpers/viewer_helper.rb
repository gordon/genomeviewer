module ViewerHelper

  ### ajax ###
  
  def ajax_replacer
    remote_function(:with => "'movement='+$('image').style.left",
                    :url =>{:action => :ajax_movement,
                            :username => @annotation.user.username,
                            :annotation => @annotation.name,
                            :seq_region => @sequence_region.seq_id,
                            :start_pos => @start,
                            :end_pos => @end})
  end
  
  ### buttons ###
  
  def zoom_out_button  
    link_to zoom_out_icon,
            :action => :index,
            :username => @annotation.user.username,
            :annotation => @annotation.name,
            :seq_region => @sequence_region.seq_id,
            :start_pos => @start-@current_lenght/4,
            :end_pos => @end+@current_lenght/4
  end
  
  def back_button
    link_to back_icon,
            :action => :index,
            :username => @annotation.user.username,
            :annotation => @annotation.name,
            :seq_region => @sequence_region.seq_id,
            :start_pos => @start-@current_lenght/2,
            :end_pos => @end -@current_lenght/2
  end
        
  def forward_button
    link_to forward_icon,
            :action => :index,
            :username => @annotation.user.username,
            :annotation => @annotation.name,
            :seq_region => @sequence_region.seq_id,
            :start_pos =>  @start+@current_lenght/2,
            :end_pos => @end+@current_lenght/2
  end
          
  def zoom_in_button 
    link_to zoom_in_icon,
            :action => :index,
            :username => @annotation.user.username,
            :annotation => @annotation.name,
            :seq_region => @sequence_region.seq_id,
            :start_pos => @start+@current_lenght/4,
            :end_pos => @end-@current_lenght/4
  end
  
  def show_all_button  
    link_to show_all_icon,
            :action => :index,
            :username => @annotation.user.username,
            :annotation => @annotation.name,
            :seq_region => @sequence_region.seq_id,
            :start_pos => @seq_begin,
            :end_pos => @seq_end
  end

  ### icons ###
  
  def zoom_out_icon
    image_tag "icons/zoom_out.png", 
              :size => "32x32", 
              :title => "zoom out", 
              :alt => "(-)"
  end
  
  def back_icon
    image_tag "icons/back.png", 
              :size => "32x32", 
              :title => "go left",
              :alt => "<<"
  end
  
  def forward_icon
    image_tag "icons/forward.png", 
              :size => "32x32", 
              :title => "go right", 
              :alt => ">>"
  end
  
  def zoom_in_icon
    image_tag "icons/zoom_in.png", 
              :size => "32x32", 
              :title => "Zoom in", 
              :alt => "(+)"
  end
  
  def show_all_icon
    image_tag "icons/show_all.png", 
              :size => "32x32", 
              :title => "view full sequence", 
              :alt => "Show all"
  end
  
end
