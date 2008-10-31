class User < ActiveRecord::Base

  ### associations ###
  has_many :annotations, :dependent => :destroy
  has_one :configuration, :dependent => :destroy

  ### callbacks ###

  after_save :find_or_create_configuration
  after_create :create_storage
  after_destroy :destroy_storage

  def create_storage
    Dir.mkdir "#{$GFF3_STORAGE_PATH}/#{self[:id]}" rescue nil
  end

  def find_or_create_configuration
    Configuration.find_or_create_by_user_id(self[:id])
  end

  def destroy_storage
    Dir.rmdir "#{$GFF3_STORAGE_PATH}/#{self[:id]}" rescue nil
  end

  ### configuration methods ###

  def reset_configuration
    configuration = Configuration.create(:user => self)
    configuration(true)
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
  # see config/routes.rb and config/invalid_usernames.yml
  validates_exclusion_of :username,
                         :in => YAML.load(IO.read("config/invalid_usernames.yml")),
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

end
