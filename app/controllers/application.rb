#
# This controller:
# - is hierarchically the parent of all other controllers
# - provides the following functionality:
#    * common settings (session_key)
#    * @current_user available in the whole application
#    * the method "enforce_login" to be used by child controllers as a filter
#
class ApplicationController < ActionController::Base
  include ExceptionNotifiable

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_genomeviewer_session_id'

  prepend_before_filter :current_user

protected

  #
  # +@current_user+ can be accessed from everywhere in the _controller_
  # and_view_ layers
  #
  # its content is:
  # - +nil+ if no user is logged in
  # - an instance of the class +User+ otherwise
  #
  def current_user # ::doc::
    @current_user = session[:user] ? User.find(session[:user]) : nil
  end

private

  #
  # +usage+::  +before_filter :enfore_login +
  #
  # +effect+:: enforces authentication for an whole controller or
  # some actions in it (using +:only+ / +:except+ options)
  #
  # if +@current_user+ is an +User+, keep going, otherwise redirect to the root
  #
  def enforce_login # ::doc::
    redirect_to root_url unless @current_user
  end

end
