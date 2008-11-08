class AccountController < ApplicationController

  before_filter :enforce_login

  # update only with method post
  %w[email password public_data].each do |x|
    verify :method => :post,
           :only => :"update_#{x}",
           :redirect_to => { :action => x }
  end
  # destroy account only with method post       
  verify :method => :post, 
         :only => :destroy, 
         :redirect_to => { :action => :delete }

  append_before_filter :title

  def title
    @title = "Account"
  end

  ### actions with a template ###

  def email
    @subtitle = "Email"
  end

  def password
    @subtitle = "Password"
    session[:tries] ||= 1
  end

  def public_data
    @subtitle = "Public Data"
  end
  
  def delete
    @subtitle = "Delete Account"
  end
  
  ### actions without template ###

  def update_public_data
    @current_user.name        = params[:current_user][:name]
    @current_user.institution = params[:current_user][:institution]
    @current_user.url         = params[:current_user][:url]
    if @current_user.save
      flash[:info] = "Your account public data have been updated"
      redirect_to account_url
    else
      render :action => :public_data
    end
  end

  def update_email
    # filter out the case where nothing changed
    # to avoid sending senseless emails
    if params[:current_user][:email] == @current_user.email
      redirect_to account_url and return
    end
    @current_user.email = params[:current_user][:email]
    if @current_user.save
      # email changed, mail a notification
      UserMailer.deliver_email_changed_message_to(@current_user)
      flash[:info] = "A notification message has been sent to the new address"
      redirect_to account_url
    else
      # error, go back to the form
      email_err = @current_user.errors[:email]
      flash[:errors] =
        @current_user.errors.count == 1 ?
          email_err + " (#{@current_user.email})" : # invalid
          email_err[0] # blank, this triggers "invalid" too, that is
                       # at the index [1], i.e. this code
      render :action => :email
    end
  end

  def update_password
    # filter out the case in which the old password was wrong:
    unless params[:old] == @current_user.password
      if (session[:tries] <= 3 rescue false)
        session[:tries] += 1
        flash[:errors] = "You entered the wrong password. Please recheck."
        redirect_to(:action => :password) and return
      else
        flash[:errors] = 'Security-driven forced logout.'
        redirect_to logout_url and return
      end
    end
    session[:tries] = nil
    # filter out the case in which the confirmation does not match
    unless params[:new] == params[:confirm]
      # confirmation failed
      flash[:errors] = "You entered two different passwords"
      redirect_to(:action => :password) and return
    end
    if @current_user.update_attributes(:password => params[:new])
      flash[:info] = "Your password was changed"
      redirect_to account_url
    else # invalid password
      flash[:errors] = @current_user.errors[:password]
      redirect_to :action => :password
    end
  end
  
  def destroy
    @current_user.destroy
    session[:user] = nil
    redirect_to root_url
  end
  
end
