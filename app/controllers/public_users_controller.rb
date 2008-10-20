class PublicUsersController < ApplicationController
  
  append_before_filter :title
  
  #
  # active_scaffold declaration and configuration
  #
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

private

  def title
    @title = "Public Annotations: Users"
  end
  
  def conditions_for_collection
    "public_annotations_count > 0"
  end
  
  def self.active_scaffold_controller_for(klass)
    return PublicAnnotationsController if klass==Annotation
    super
  end
  
  #
  # only users with public_annotations_count > 0 may be accessed
  #
  def public_user?
    if params["id"] # == only for actions working on a single record
      user = User.find(params["id"])
      redirect_to root_url unless user.public_annotations_count > 0
    end
  end
  alias_method :list_authorized?, :public_user?
  
end