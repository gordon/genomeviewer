class User < ActiveRecord::Base

  ### associations ###
  has_many :annotations

  ### validations ###
  validates_uniqueness_of :email, :message => "This account already exists. Please choose another one."
  validates_presence_of :name, :message => "Please enter your full name"
  validates_presence_of :email, :message => "Please enter your email address"
  validates_presence_of :password, :message => "Please choose a password"
  validates_length_of :name, :in => 4..64, :too_short => "Your name should be at least %d characters long", :too_long => "Please enter a name shorter than %d characters"
  validates_length_of :email, :maximum => 64, :too_long => "The entered email address is too long (max 64 chars)"
  validates_confirmation_of :password, :message => "You entered two different passwords!"
  validates_format_of :email, :with => /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i, :message => 'Email address invalid'

  ### virtual columns ###
  
  # Returns the relative path (to the application main directory) 
  # to the repository of upload files for this user.
  # Returns nil for new users that were not yet saved
  def uploads_dir
    new_record? ? nil : "uploads/users/#{self[:id]}"
  end

  ### callbacks ###
  
  before_save :hash_password
  # avoids privacy problems involved in storing user passwords as plain text
  def hash_password
    self[:password] = Digest::SHA1.hexdigest(self[:password])
  end
  
  # note: uploads_dir is defined after save; on other words:  
  #       you get an #id after saving, so don't change the
  #       callback to any before_save
  after_save :create_uploads_dir
  # creates a directory where the user can store own GFF3 files
  def create_uploads_dir
    Dir.mkdir(uploads_dir)
    logger.info("Created directory for new user #{name} (ID:#{id})")
  end

  before_destroy :delete_annotations
  # delete all annotations of an user that is being 
  # deleted to ensure db consistency
  # (delete cascade behaviour)
  def delete_annotations
    p annotations
    p "**************************"
    # TODO: eventually insert here some code to save public
    # annotations in another directory if this behaviour is desired
    annotations.destroy_all
    p annotations
  end
  
  after_destroy :delete_uploads_dir
  # delete the duploads directory of an user 
  # 
  # note: the directory should at this point be already empty 
  # because of the delete_annotations method call by before_destroy
  def delete_uploads_dir
    # the following commented code would delete all files in it 
    #~ main_app_dir = Dir.getwd
    #~ Dir.chdir(uploads_dir)
    #~ Dir["*"].each {|filename| File.delete(filename)}
    #~ Dir.chdir(main_app_dir)
    Dir.delete(uploads_dir)
  end

end
