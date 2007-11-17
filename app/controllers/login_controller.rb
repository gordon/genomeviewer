class LoginController < ApplicationController
  
 def login
   @page_title = "Genomeviewer - User Login"
 end
 def login_fail
   @page_title = "Login Failed"
 end
 def login_ok
   @page_title = "Login Successful"
  end
 
 
 def do_login
  if User.find_by_login_and_password(params[:user], params[:pass])
   session[:user]=params[:user]
   redirect_to :controller => :in_session, :action => :index
  else
   redirect_to :controller => :login, :action => :login_fail
  end
 end
end
