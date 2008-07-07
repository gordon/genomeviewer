class PublicAnnotationsController < ApplicationController

  active_scaffold :annotations do |config|
    
    config.columns = [:name, :description, :sequence_regions]
    
    # make it readonly, in addition exclude also show, which is uninteresting for the purpose
    [:create, :update, :new, :delete, :show].each do |act|
      config.actions.exclude act
    end
    
    config.action_links.add :view, 
                                   :type => :record,
                                   :controller => "browser",
                                   :parameters => {:action => "seq_id_select", 
                                                           :annotation => 2}
    
  end
  
  def conditions_for_collection
    "public != 'f' and public != 0"
  end
 
end