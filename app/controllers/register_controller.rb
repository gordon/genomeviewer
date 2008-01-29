class RegisterController < ApplicationController

  def register
    # create a new user instance if here for the first time
    # or load it from the flash if coming back because of errors
    @user = flash[:user]||User.new
  end   
  
  def do_register
    # create an user instance using the form parameters 
    @user = User.new(params[:user])
    # try to save
    if @user.save
      # if successful:
      # go to the login page, displaying a success message
      flash[:notice] = "Registration successful, you can login now."
      redirect_to login_url
    else
      # back to the form if there was a problem
      flash[:user] = @user
      redirect_to :action => :register 
    end
  end

  private
 
  def initialize
    @title = "Genomeviewer - User Registration"
    # load the stylesheet to format errors in forms
    @stylesheets = 'form_errors'
    super
  end
  
end

