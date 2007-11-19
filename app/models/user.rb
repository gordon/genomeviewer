class User < ActiveRecord::Base

 validates_uniqueness_of :login, :message => "This login is already in use. Please choose another one."

 validates_presence_of :login, :message => "Please enter a login between 4 and 16 characters"
 validates_presence_of :name, :message => "Please enter your full name"
 validates_presence_of :email, :message => "Please enter your email address"
 validates_presence_of :password, :message => "Please choose a password"

 validates_length_of :name, :in => 4..64, :too_short => "Your name should be at least %d characters long", :too_long => "Please enter a name shorter than %d characters"
 validates_length_of :login, :in => 4..16
 
 validates_confirmation_of :password, :message => "You entered two different passwords!"

 validates_format_of :login, :with => /[A-Z0-9]+/i, :message => "Login invalid, use only alphanumeric characters."
 validates_format_of :email, :with => /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i, :message => 'Email address invalid'
 
end
