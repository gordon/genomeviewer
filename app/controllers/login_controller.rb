class LoginController < ApplicationController
   
  def login
    @title="GenomeViewer - Login"
  end
   
  def do_login
    hashed_password = Digest::SHA1.hexdigest(params[:password])
    user = User.find_by_email_and_password(params[:email], hashed_password)
    if user
      session[:user]=user.id
      redirect_to :controller => :in_session, :action => :index
    else
      flash[:errors] = 
        "Login failed!<br/>"+
        "You have supplied invalid login information.<br/>"+
        "Do you want to <a href="+registration_url+">register</a> "+
        "a new account?"
      redirect_to login_url
    end
  end
   
end
