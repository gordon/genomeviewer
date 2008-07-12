class LoginController < ApplicationController

  ### actions with a template ###

  def login
    @title="Login"
  end

  ### actions redirecting to other actions ###

  def do_login
    #hashed_password = Digest::SHA1.hexdigest(params[:password])
    user = User.find_by_email_and_password(params[:email], params[:password])
    if user
      session[:user]=user.id
      flash[:info] = "Thank you for logging in, #{user.name}!"
      if ["default", "register"].include? params[:back_to][:controller]
        redirect_to :controller => :in_session, :action => :file_manager
      else
        redirect_to params[:back_to]
      end
    else
      flash[:errors] =
        "Login failed!<br/>"+
        "You have supplied invalid login information.<br/>"+
        "Do you want to <a href="+registration_url+">register</a> "+
        "a new account?"
      redirect_to params[:back_to]
    end
  end

end
