class DefaultController < ApplicationController

  ### actions with a template ###

  def index
    @title = "Welcome to the GenomeViewer"
  end

  ### actions redirecting to other actions ###

  def do_login
    user = User.find_by_email_and_password(params[:user][:email], 
                                           params[:user][:password])
    if user
      session[:user]=user.id
      flash[:info] ? flash.keep : (flash[:info] = "Thank you for logging in, #{user.name}!")
      if !params[:back_to] or 
      ["default", "register"].include? params[:back_to][:controller]
        redirect_to own_files_url
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
