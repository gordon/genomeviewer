#
# This controller is responsible for:
# - the homepage
# - user login and logout
#
class DefaultController < ApplicationController

  ### actions with a template ###
  
  #
  # the homepage
  #
  def index
    @title = "Welcome to the GenomeViewer"
  end

  ### actions redirecting to other actions ###

  #
  # sets session[:user] to nil and tries to redirect to a 
  # meaningful place (which is in some cases the homepage)  
  #
  def do_logout
    session[:user] = nil
    redirect_to params[:back_to] ? params[:back_to] : root_url
  end
  
  # 
  # - works using params[:user][:username] and [:password] 
  #
  # - if the authentication succeeds: 
  #   => user.id saved in session[:user] 
  #   => welcome message
  #
  # - if the authentication fails:
  #   => error message 
  def do_login
    user = User.find_by_username_and_password(params[:user][:username], 
                                           params[:user][:password])
    if user
      session[:user]=user.id
      flash[:info] ? flash.keep : (flash[:info] = 
        "Thank you for logging in, #{user.name}!")
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
