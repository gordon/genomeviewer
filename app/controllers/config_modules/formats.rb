module ConfigModules::Formats

  ### actions with a template ###

  def config_formats
    user = User.find(session[:user])
    @formats = user.drawing_format_configuration || DrawingFormatConfiguration.new
    @title = "Configuration"
    @subtitle = "Drawing Formats"
  end
  
  ### actions redirecting to other actions ###
  
  def do_config_formats
    params[:format]["show_grid"] ||= false 
    user = User.find(session[:user])
    dfc = DrawingFormatConfiguration.new(params[:format])
    user.drawing_format_configuration = dfc
    user.save
    redirect_to :action => :config_formats
  end
  
  def do_reset_formats
    user = User.find(session[:user])
    user.drawing_format_configuration = nil
    user.save
    redirect_to :action => :config_formats
  end

end