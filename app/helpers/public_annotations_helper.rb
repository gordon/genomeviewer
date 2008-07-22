module PublicAnnotationsHelper

  def user_column(record)
    link_to record.user.name, 
            :controller => :public_annotations, 
            :action => :user, 
            :username => record.user.username
  end
  
  def sequence_regions_column(record)
    record.sequence_regions.map do |sr|
      link_to sr.seq_id, 
              :controller => :viewer, 
              :username => record.user.username,
              :annotation => record.name,
              :seq_region => sr.seq_id
    end.join(", ")
  end
  
  def description_column(record)
    simple_format(record.description)
  end

end