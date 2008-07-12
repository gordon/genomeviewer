class RegisterController < ApplicationController

  ### actions with a template ###

  def register
    # create a new user instance if here for the first time
    # or load it from the flash if coming back because of errors
    @title = "Create a new account"
    @user = flash[:user]||User.new
  end

  def recover_password
    @title = "Recover your password"
    @user = User.new(:email => flash[:email])
  end
  
  def password_recovery_email_sent
    @title = "Password recovered"
    @user = User.find_by_email(flash[:email])
  end
  
  ### actions redirecting to other actions ###
  
  def do_register
    # create an user instance using the form parameters
    @user = User.new(params[:user])
    # try to save
    if @user.save
      # if successful:
      # send a signup notification
      UserMailer.deliver_signup_notification_to(@user)
      # go to the login page, displaying a success message
      flash[:info] = "Thank you for registering.<br/>
                A signup notification email has been sent to #{@user.email}."
      redirect_to login_url(:user => params[:user])
    else
      # back to the form if there was a problem
      flash[:user] = @user
      redirect_to :action => :register
    end
  end  
  
  def send_password_recovery_email
    flash[:email]=params[:user][:email]
    @user = User.find_by_email(params[:user][:email])
    if @user
      UserMailer.deliver_password_recovery_email_to(@user)
      redirect_to :action => :password_recovery_email_sent
    else
      flash[:errors]="Sorry, no user was registered under this email address."
      redirect_to :action => :recover_password
    end
  end

end
