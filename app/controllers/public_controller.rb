class PublicController < ApplicationController

  after_filter :initializations
  def initializations
    @stylesheets = "in_session"
    @title = "Genomeviewer - Public files"
    @partial = session[:user] ? "/in_session/navbar" : "/public/navbar"
  end
  private :initializations

  def show_users
    @users = User.find(:all).delete_if {|user| not user.annotations.find_by_public(true)}
  end

  def show_user_files
    @user = User.find(params[:user_id])
    @annotations = @user.annotations.find_all_by_public(true)
  end

end
