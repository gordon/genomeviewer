class PublicController < ApplicationController
 def showusers
  partial = session[:user] ? "/in_session/navbar" : "/public/navbar"
  @navbar = (render_to_string :partial => partial)
 end

 def showuserfiles
  partial = session[:user] ? "/in_session/navbar" : "/public/navbar"
  @navbar = (render_to_string :partial => partial)
 end

 private

 def initialize
  @stylesheets = "in_session"
 end
end
