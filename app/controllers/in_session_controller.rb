class InSessionController < ApplicationController

 prepend_before_filter :check_login
 layout "in_session_frameset"

 def check_login
  unless session[:user]
   redirect_to :controller => :login, :action => :login
   session[:location]=params.clone
  end
  return true
 end

 def doLogout
  session[:user]=nil
  redirect_to :controller => :default, :action => :index
 end

  def doUpload
    File.open("uploads/users/#{session[:user]}/#{params[:gff3File].original_filename()}", "wb") { |f| f.write(params[:gff3File].read) }
    redirect_to :action => "upload"
  end

end