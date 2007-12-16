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
    filename = "uploads/users/#{session[:user]}/#{params[:gff3_file].original_filename()}"
    File.open(filename, "wb") {|f| f.write(params[:gff3_file].read) }
    @annotation = Annotation.create(:datasource => filename,
					   :user_id => session[:user],
					   :description => params[:description])
    if @annotation
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