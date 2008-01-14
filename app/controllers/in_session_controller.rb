class InSessionController < ApplicationController

 prepend_before_filter :check_login

 def check_login
  unless session[:user]
   redirect_to :controller => :login, :action => :login
   session[:location]=params.clone
  end
  return true
 end

 def do_logout
  session[:user]=nil
  redirect_to :controller => :default, :action => :index
 end

 def do_upload
  @annotation = Annotation.new
  @annotation.name = params[:gff3_file].original_filename
  @annotation.user_id = session[:user]
  @annotation.description = params[:description] 
  @annotation.gff3_data = params[:gff3_file].read
  if @annotation.save
   flash[:notice] = "Successfully uploaded"
  else
   flash[:errors] = @annotation.errors.on_base
  end
  redirect_to :action => "upload"
 end

 def change_annotation_description
  annotation=Annotation.find(params[:annotation].to_i)
  # prevent others from mofifiing our data
  if annotation.user.id == session[:user]
   annotation.description=params[:description]
   annotation.save
  end
  redirect_to :action => "file_manager"
 end

 def file_delete
  annotation=Annotation.find(params[:annotation].to_i)
  # prevent others from mofifiing our data
  if annotation.user.id == session[:user]
   annotation.destroy
  end
  redirect_to :action => "file_manager"
 end

 def file_accessibility
  annotation=Annotation.find(params[:annotation].to_i)
  if params[:scope] then scope=false else scope=true end
  # prevent others from mofifiing our data
  if annotation.user.id == session[:user]
   annotation.public=scope
   annotation.save
  end
  redirect_to :action => "file_manager"
 end

 private

 def initialize
  @stylesheets = "in_session", "menu"
 end

end