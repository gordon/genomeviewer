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
    if @start == @seq_begin and @end == @seq_end 
      return zoom_out_icon_inactive
    else      
      return link_to zoom_out_icon,
                     :action => :index,
                     :username => @annotation.user.username,
                     :annotation => @annotation.name,
                     :seq_region => @sequence_region.seq_id,
                     :start_pos => (@start-@current_lenght/4).round,
                     :end_pos => (@end+@current_lenght/4).round
    end
  end
  
  def back_button
    if @start == @seq_begin
      return back_icon_inactive
    else      
      old_window = @end-@start+1
      new_start = @start - (old_window*@current_lenght/2).round     
      new_start = @seq_begin if new_start < @seq_begin
      new_start = @end -1 if new_start >= @end        
      
      new_end = new_start + old_window
      if new_end > @seq_end 
        new_end = @seq_end 
        new_start = new_end - old_window
      end
      return link_to back_icon,
            :action => :index,
            :username => @annotation.user.username,
            :annotation => @annotation.name,
            :seq_region => @sequence_region.seq_id,
            :start_pos =>  new_start,
            :end_pos => new_end
    end
  end
        
  def forward_button
    if @end == @seq_end 
      return forward_icon_inactive
    else      
      old_window = @end-@start+1      
      new_start = @start + (old_window*@current_lenght/2).round     
      new_start = @seq_begin if new_start < @seq_begin
      new_start = @end -1 if new_start >= @end        
      
      new_end = new_start + old_window
      if new_end > @seq_end 
        new_end = @seq_end 
        new_start = new_end - old_window
      end
      return link_to forward_icon,
            :action => :index,
            :username => @annotation.user.username,
            :annotation => @annotation.name,
            :seq_region => @sequence_region.seq_id,
            :start_pos =>  new_start,
            :end_pos => new_end
    end
  end
          
  def zoom_in_button 
    new_start = (@start+@current_lenght/4).round
    new_end = (@end-@current_lenght/4).round
    if new_end-new_start < 10
      return zoom_in_icon_inactive
    else
      return link_to zoom_in_icon,
                     :action => :index,
                     :username => @annotation.user.username,
                     :annotation => @annotation.name,
                     :seq_region => @sequence_region.seq_id,
                     :start_pos => new_start,
                     :end_pos => new_end
    end
  end
  
  def show_all_button  
    if @start == @seq_begin and @end == @seq_end
      return show_all_icon_inactive
    else      
      return link_to show_all_icon,
                     :action => :index,
                     :username => @annotation.user.username,
                     :annotation => @annotation.name,
                     :seq_region => @sequence_region.seq_id,
                     :start_pos => @seq_begin,
                     :end_pos => @seq_end
    end
  end

  ### icons ###
  
  def zoom_out_icon
    image_tag "icons/zoom_out.png", 
              :size => "32x32", 
              :title => "zoom out", 
              :alt => "(-)"
  end
  
  def zoom_out_icon_inactive
    image_tag "icons/zoom_out_inactive.png", 
              :size => "32x32", 
              :title => "you already see the whole sequence", 
              :alt => "[-]"
  end
  
  def back_icon
    image_tag "icons/back.png", 
              :size => "32x32", 
              :title => "go left",
              :alt => "<<"
  end
            
  def back_icon_inactive
    image_tag "icons/back_inactive.png", 
              :size => "32x32", 
              :title => "you are at the beginning",
              :alt => "|<<"
  end
  
  def forward_icon
    image_tag "icons/forward.png", 
              :size => "32x32", 
              :title => "go right", 
              :alt => ">>"
  end

  def forward_icon_inactive
    image_tag "icons/forward_inactive.png", 
              :size => "32x32", 
              :title => "you are at the end", 
              :alt => ">>|"
  end
  
  def zoom_in_icon
    image_tag "icons/zoom_in.png", 
              :size => "32x32", 
              :title => "Zoom in", 
              :alt => "(+)"
  end
  
  def zoom_in_icon_inactive
    image_tag "icons/zoom_in_inactive.png", 
              :size => "32x32", 
              :title => "Zoom in", 
              :alt => "(+)"
  end
            
  def show_all_icon
    image_tag "icons/show_all.png", 
              :size => "32x32", 
              :title => "view full sequence", 
              :alt => "|<-->|"
  end

  def show_all_icon_inactive
    image_tag "icons/show_all_inactive.png", 
              :size => "32x32", 
              :title => "you already see the whole sequence", 
              :alt => "[<-->]"
  end

end
