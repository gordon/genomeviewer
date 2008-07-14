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

  def create_feature_class
    @title = "Configuration"
    @subtitle = "Create a Feature Class"
  end
  
  # see also in the included modules 
  
  ### actions redirecting to other actions ###

  def do_logout
    session[:user]=nil
    redirect_to params[:back_to]
  end

  def do_create_feature_class
    fc = FeatureClass.new(params[:feature_class])
    if fc.save
      flash[:notice] = "New feature class #{fc.name} created successfully."
    else
      flash[:errors] = "Impossible to create #{fc.name}.<br/>Does it already exist?"
    end
    redirect_to :action => :create_feature_class
  end
  
  # see also in the included modules

end
