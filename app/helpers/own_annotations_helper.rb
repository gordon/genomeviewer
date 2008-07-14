module OwnAnnotationsHelper
  include PublicAnnotationsHelper
  
  def public_column(record)
    make_it_private = remote_function :url => {:action => :file_access_control,
                                               :id => record.id,
                                               :checked => :private}
    make_it_public  = remote_function :url => {:action => :file_access_control,
                                               :id => record.id,
                                               :checked => :public}
    html = ""
    html << (radio_button_tag "access_#{record.id}", 
                              "private", !record.public,
                              :id => "access_#{record.id}_private",
                              :onclick => make_it_private)
    html << "Private" 
    html << tag(:br) 
    html << (radio_button_tag "access_#{record.id}", 
                              "public", record.public,
                              :id => "access_#{record.id}_public",
                              :onclick => make_it_public) 
    html << "Public" 
    return html
  end
  
end
