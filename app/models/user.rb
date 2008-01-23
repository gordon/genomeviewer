class User < ActiveRecord::Base

  ### associations ###
  has_many :annotations, :dependent => :destroy
  has_many :color_configurations, :dependent => :destroy
  has_many :feature_style_configurations, :dependent => :destroy
  has_one :drawing_format_configuration, :dependent => :destroy
  has_many :domination_configurations, :dependent => :destroy
  has_one :collapsing_configuration, :dependent => :destroy

  ### validations ###
  validates_uniqueness_of :email, :message => "This account already exists. Please choose another one."
  validates_presence_of :name, :message => "Please enter your full name"
  validates_presence_of :email, :message => "Please enter your email address"
  validates_presence_of :password, :message => "Please choose a password"
  validates_length_of :name, :in => 4..64, :too_short => "Your name should be at least %d characters long", :too_long => "Please enter a name shorter than %d characters"
  validates_length_of :email, :maximum => 64, :too_long => "The ente:red email address is too long (max 64 chars)"
  validates_confirmation_of :password, :message => "You ente:red two different passwords!"
  validates_format_of :email, :with => /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i, :message => 'Email address invalid'

  ### callbacks ###
  
  before_save :hash_password
  # avoids privacy problems involved in storing user passwords as plain text
  def hash_password
    self[:password] = Digest::SHA1.hexdigest(self[:password])
  end
    
end
