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
 user = User.find_by_login_and_password(params[:user], params[:pass])
  if user
   session[:user]=user.id
   redirect_to :controller => :in_session, :action => :index
  else
   redirect_to :controller => :login, :action => :login_fail
  end
 end
 
 private
 def initialize
  @title="GenomeViewer - Login"
  super
 end
end
