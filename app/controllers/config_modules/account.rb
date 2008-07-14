module ConfigModules::Account

  ### actions with a template ###

  def config_email
    @title = "Configuration"
    @subtitle = "Email"
    @user = User.find(session[:user])
  end
  
  def config_personal_info
    @title = "Configuration"
    @subtitle = "Personal Information"
    @user = flash[:user] || User.find(session[:user]) 
  end

  ### actions redirecting to other actions ###
  
  def do_config_email
    @user = User.find(session[:user])
    if params[:user][:email] == @user.email
      # nothing changed
      redirect_to configuration_url
    else
      # try to change email
      if @user.update_attributes(params[:user])
        # email changed
        UserMailer.deliver_email_changed_message_to(@user)
        flash[:info] = "A notification message has been sent to the new address"
        redirect_to configuration_url
      else
        # error, go back to the form
        flash[:errors] = @user.errors[:email].kind_of?(String) ? 
                         "#{@user.errors[:email]} (#{params[:user][:email]})" : 
                            @user.errors[:email][0]
        redirect_to :action => :config_email
      end
    end
  end
    
  def do_config_personal_info
    @user = User.find(session[:user])
    # try to change parameters
    if @user.update_attributes(params[:user])
      # success
      flash[:info] = "Your account has been updated"
      redirect_to configuration_url
    else
      # error, go back to the form
      flash[:user] = @user
      redirect_to :action => :config_personal_info
    end
  end

end
