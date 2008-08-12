class PublicUsersController < ApplicationController
  
  append_before_filter :title
  
  def title
    @title = "Public Annotations: Users"
  end
  
  active_scaffold :user do |config|
    
    config.columns = [:name, :institution, :url, :public_annotations_count]
    config.columns[:public_annotations_count].label = "Public Annotations"
    config.columns[:url].label = "Homepage"
    
    # make it readonly, in addition exclude also show, which is uninteresting for the purpose
    [:create, :update, :new, :delete, :show].each do |act|
      config.actions.exclude act
    end
            
    config.list.sorting = { :public_annotations_count => :desc } 

    config.nested.add_link "Show Annotations", [:annotations]
    
  end
  
  def conditions_for_collection
    "public_annotations_count > 0"
  end
  
  def self.active_scaffold_controller_for(klass)
    return PublicAnnotationsController if klass==Annotation
    super
  end

end