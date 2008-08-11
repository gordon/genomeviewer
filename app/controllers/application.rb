# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_genomeviewer_session_id'
  
  prepend_before_filter :get_current_user
  
  private
  
  def get_current_user
    @current_user = session[:user] ? User.find(session[:user]) : nil
  end
  
  def enforce_login
    redirect_to root_url unless @current_user
  end

end
