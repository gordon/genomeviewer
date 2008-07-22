class PublicAnnotationsController < ApplicationController

  active_scaffold :annotations do |config|
    
    config.label = @title
    
    config.columns = [:name, :description, :user, :sequence_regions]
    
    # make it readonly, in addition exclude also show, which is uninteresting for the purpose
    [:create, :update, :new, :delete, :show].each do |act|
      config.actions.exclude act
    end
    
    config.action_links.add :open, :type => :record, :page => true
    
  end
  
  def conditions_for_collection
    "public != 'f' and public != 0"
  end
 
  def open
    annotation = Annotation.find(params["id"])
    redirect_to :controller => :viewer, 
                    :annotation => annotation.name, 
                    :username => annotation.user.username
  end
  
  def self.active_scaffold_controller_for(klass)
    return PublicUsersController if klass==User
    super
  end
 
  def user
    @public_user = User.find_by_username(params[:username])
    if !@public_user
      flash[:errors] = "#{params[:username]}: user not found"
      redirect_to :action => :index 
    elsif @public_user.public_annotations_count == 0
      flash[:errors] = "#{params[:username]} has no public annotations"
      redirect_to :action => :index
    end
    @title = @public_user.name
  end
 
  private
  
  def initialize
    @title = "Public Annotations"
    super
  end
  
end