class User < ActiveRecord::Base

  ### associations ###
  has_many :annotations, :dependent => :destroy
  has_many :feature_types, :dependent => :destroy
  
  # configuration objects: if not existing, standard configuration will be used
  # => see config method
  has_one  :drawing_format_configuration, :dependent => :destroy
  has_one  :collapsing_configuration,     :dependent => :destroy
  has_many :color_configurations,         :dependent => :destroy
  has_many :feature_style_configurations, :dependent => :destroy
  has_many :domination_configurations,    :dependent => :destroy

  ### callbacks ###
  
  after_create :create_storage
  after_destroy :destroy_storage
  
  def create_storage
    Dir.mkdir "#{$GFF3_STORAGE_PATH}/#{self[:id]}" rescue nil
  end
  
  def destroy_storage
    Dir.rmdir "#{$GFF3_STORAGE_PATH}/#{self[:id]}" rescue nil
  end
  
  ### validations ###

  # login name
  validates_presence_of :username,
                        :message => 'Please enter an username'
  validates_format_of :username, 
                       :with => /^[A-Z0-9\._]+$/i,
                       :message => "Usernames can only contain letters, numbers, dots (.) and undescores (_)."
  validates_uniqueness_of :username, 
                          :message => "This username is already in use."
  
  # the following names are invalid and can't be used as username
  # see config/routes.rb
  validates_exclusion_of :username,
                         :in => %w[login logout registration recover_password 
                         configuration files public default in_session viewer
                         own_annotations public_annotations public_users 
                         register image move images javascripts stylesheets],
                         :message => "This username is reserved. Please choose a different one."
  
  # email
  validates_presence_of :email, :message => "Please enter your email address"
  validates_uniqueness_of :email,
        :message => "This account already exists. Please choose another one."
  validates_length_of :email, :maximum => 64,
          :too_long => "The entered email address is too long (max 64 chars)"
  validates_format_of :email,
                      :with => /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i,
                      :message => 'Email address invalid'

  # name
  validates_presence_of :name, :message => "Please enter your full name"
  validates_length_of :name,
              :in => 4..64,
              :too_short => "Your name should be at least %d characters long",
              :too_long => "Please enter a name shorter than %d characters"

  # password
  validates_presence_of :password, :message => "Please choose a password"
  validates_confirmation_of :password,
                            :message => "You entered two different passwords!"
  validates_length_of :password, :maximum => 40,
          :too_long => "The entered password is too long (max 40 chars)"

  ### virtual attributes ###

  # returns the desired image width
  def width(default = 800)
     drawing_format_configuration ?
        drawing_format_configuration.width :
        default
  end

  include ConfigObjectLoaders
  
  # returns the (eventually cached) GT::Config object 
  # with the personalisations for this user
  def config
    unless @config_object
      cached = GTServer.cached_config_for?(self[:id])
      @config_object = GTServer.config_object_for_user(self[:id])
      # see ConfigObjectLoaders module for the next:
      load_user_specific_configurations unless cached
    end
    @config_object
  end
  
  def flush_config_cache
    GTServer.config_object_for_user(self[:id], :delete_cache => true)
    @config_object = nil
  end

end
