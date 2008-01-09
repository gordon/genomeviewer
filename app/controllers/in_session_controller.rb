class InSessionController < ApplicationController

 prepend_before_filter :check_login

 def view
   @sequence_region = Annotation.find(params[:annotation]).sequence_regions[0]
 end

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
      flash[:notice] = "Upload impossible"
    end
    redirect_to :action => "upload"
  end

 private

  def initialize
   @stylesheets = "in_session", "menu"
  end

end