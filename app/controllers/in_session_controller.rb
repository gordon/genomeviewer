class InSessionController < ApplicationController

  prepend_before_filter :check_login
  def check_login
    redirect_to root_url unless session[:user]
    return true
  end

  include ConfigModules::Account
  include ConfigModules::Formats
  include ConfigModules::Colors
  include ConfigModules::Styles
  include ConfigModules::Dominations
  include ConfigModules::Collapse

  ### actions with a template ###

  def view
    @annotation = Annotation.find(params[:annotation])
    @seq_region = SequenceRegion.find(params[:seq_region])
    @title = "Viewing #{@annotation.name} / #{@seq_region.seq_id}"
  end
  
  def config
    @title = "Configuration"
  end
  
  # see also in the included modules 
  
  ### actions redirecting to other actions ###

  def do_logout
    session[:user]=nil
    redirect_to params[:back_to]
  end
  
  # see also in the included modules

end
