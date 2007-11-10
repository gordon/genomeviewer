class RegisterController < ApplicationController
 def checkRegister
  if User.find_by_login(params[:login])
   redirect_to :action => :login_not_avail
  else
   if params[:email].match(/\@(.+)/)
    session[:tmp_login]=params[:login]
    session[:tmp_name]=params[:name]
    session[:tmp_email]=params[:email]
    redirect_to :action => :doRegister
   else
    redirect_to :action => :bad_data
   end
  end
 end

 def doRegister
  password="m1"
  Dir.mkdir("uploads/users/#{session[:tmp_login]}")
  User.create(:login=>session[:tmp_login],:password=>password,:name=>session[:tmp_name],:email=>session[:tmp_email])
  session[:tmp_login]=nil
  session[:tmp_name]=nil
  session[:tmp_email]=nil
  redirect_to :action => :register_succ
 end
end
