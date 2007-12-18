class User < ActiveRecord::Base

 has_many :annotations

 validates_uniqueness_of :email, :message => "This account already exists. Please choose another one."

 validates_presence_of :name, :message => "Please enter your full name"
 validates_presence_of :email, :message => "Please enter your email address"
 validates_presence_of :password, :message => "Please choose a password"

 validates_length_of :name, :in => 4..64, :too_short => "Your name should be at least %d characters long", :too_long => "Please enter a name shorter than %d characters"
 validates_length_of :email, :maximum => 64, :too_long => "The entered email address is too long (max 64 chars)"
 
 validates_confirmation_of :password, :message => "You entered two different passwords!"

 validates_format_of :email, :with => /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i, :message => 'Email address invalid'
 
 before_save :hash_password

 def hash_password
   self[:password] = Digest::SHA1.hexdigest(self[:password])
 end

end
