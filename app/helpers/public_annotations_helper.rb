module PublicAnnotationsHelper

  def user_column(record)
    link_to record.user.name, :controller => :public_users, 
                                       :action => :nested, 
                                       :id => record.user.id, 
                                       :associations => "annotations"
  end
  
  def sequence_regions_column(record)
    link_to record.sequence_regions.map(&:seq_id).join(", "), 
            :controller => :public_annotations, 
            :action => :open,
            :id => record.id
  end

end