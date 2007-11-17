class LoginController < ApplicationController
 def do_login
  if User.find_by_login_and_password(params[:user], params[:pass])
   session[:user]=params[:user]
   redirect_to :controller => :in_session, :action => :index
  else
   redirect_to :controller => :login, :action => :login_fail
  end
 end
end
