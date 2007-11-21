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
 password_hash = Digest::SHA1.hexdigest(params[:password])
 user = User.find_by_email_and_password(params[:email], password_hash)
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
