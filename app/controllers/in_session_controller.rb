class InSessionController < ApplicationController

 prepend_before_filter :check_login

 include FileManager
 
 include ConfigModules::Formats
 include ConfigModules::Colors
 include ConfigModules::Styles
 include ConfigModules::Dominations
 include ConfigModules::Collapse

 def check_login
  unless session[:user]
   redirect_to login_url
   session[:location]=params.clone
  end
  return true
 end

 def do_logout
  session[:user]=nil
  redirect_to root_url
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

end
