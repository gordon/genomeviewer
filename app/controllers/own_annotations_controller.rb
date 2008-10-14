#
# ActiveScaffold based controller responsible of 
# the page which allows to upload (or delete) GFF3 files, to 
# change the description and to set the "public" bit.
#
class OwnAnnotationsController < ApplicationController
  
  before_filter :enforce_login
  
  #
  # active_scaffold declaration and configuration
  #
  active_scaffold :annotations do |config|
  
    # the show action is not useful, as everything is already in the list
    config.actions.exclude :show
    
    # the create action will be used for uploads
    config.create.link.label = "Upload&nbsp;GFF3"
    config.create.multipart = true
    
    config.list.columns = [:name, :description, :sequence_regions, :public]
    config.columns[:public].label = "File&nbsp;Access"
    
    # link to "open" action (which redirects then to the Viewer)
    config.action_links.add :open,
                            :label => "Open",
                            :type => :record, 
                            :page => true
  end
  
  #
  # a link to this action is displayed for all annotations in the list
  # and redirects to the viewer, opening the corresponding annotation
  #
  def open 
    annotation = Annotation.find(params["id"])
    redirect_to :controller => :viewer, 
                :annotation => annotation.name, 
                :username => annotation.user.username
  end
  
  ### ajax actions ###
  
  #
  # turns on or off the "public" bit of an annotation
  # it is called by the "public_column" helper 
  #
  def file_access_control
    annotation = Annotation.find(params[:id])
    user = User.find(session[:user])
    # prevent others from modifying own data
    if annotation.user == user
      previously_public = annotation.public
      annotation.public = (params[:checked]=="public")
      if annotation.public
        user.increment(:public_annotations_count) unless previously_public        
      else # private
        user.decrement(:public_annotations_count) if previously_public
      end
      ActiveRecord::Base.transaction do 
        user.save
        annotation.save
      end
      render :inline => '', :status => 200
    else 
      render :inline => "Authorization Error. Are you logged in?", :status => 500
    end
  end  

private
  
  #
  # only current_user's records are listed
  #
  def conditions_for_collection #::doc::
    ["user_id = ?", session[:user]]
  end
  
  #
  # this code is executed after the upload and works as an junction
  # between the file upload and the Annotation file+DB based model
  #
  def after_upload(record) #::doc::
    record.name = params[:record][:gff3_file].original_filename
    record.user_id = session[:user]
    record.gff3_data = params[:record][:gff3_file].read
  end

  alias_method :before_create_save, :after_upload

  def initialize
    @title = "My Annotations"
    super
  end
    
end
