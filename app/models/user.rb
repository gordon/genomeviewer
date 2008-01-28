class User < ActiveRecord::Base

  ### associations ###
  has_many :annotations, :dependent => :destroy
  has_many :color_configurations, :dependent => :destroy
  has_many :feature_style_configurations, :dependent => :destroy
  has_one :drawing_format_configuration, :dependent => :destroy
  has_one :collapsing_configuration, :dependent => :destroy
  has_many :domination_configurations, :dependent => :destroy 
  
  ### validations ###
  validates_uniqueness_of :email, :message => "This account already exists. Please choose another one."
  validates_presence_of :name, :message => "Please enter your full name"
  validates_presence_of :email, :message => "Please enter your email address"
  validates_presence_of :password, :message => "Please choose a password"
  validates_length_of :name, :in => 4..64, :too_short => "Your name should be at least %d characters long", :too_long => "Please enter a name shorter than %d characters"
  validates_length_of :email, :maximum => 64, :too_long => "The entered email address is too long (max 64 chars)"
  validates_confirmation_of :password, :message => "You entered two different passwords!"
  validates_format_of :email, :with => /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i, :message => 'Email address invalid'

  ### callbacks ###
  
  before_save :hash_password 
  # avoids privacy problems involved in storing user passwords as plain text
  def hash_password
    self[:password] = Digest::SHA1.hexdigest(self[:password])
  end
  
  # returns a GT::Config object with the personalisations for this user
  def config
    c = GTSvr.getConfigObject
    # load default configuration
    c.load_file(File.expand_path("config/view.lua"))
    # load user specific colors
    color_configurations.each do |record|
      color = GTSvr.getColorObject()
      color.red    = record.red.to_f
      color.green = record.green.to_f
      color.blue   = record.blue.to_f
      c.set_color(record.element.name,color)
    end
    # load user specific feature styles
    feature_style_configurations.each do |record|
      c.set_cstr("feature_styles",record.feature_class.name,record.style.name)
    end
    # load user specific formats
    if drawing_format_configuration
      # set show_grid
      c.set_cstr("format","show_grid", drawing_format_configuration.show_grid ? "yes" : "no")
      # set all other format attributes 
      format_attributes = (drawing_format_configuration.pixel_attribute_names)
      format_attributes.each do |attribute|
        c.set_num("format",attribute,drawing_format_configuration.send(attribute).to_f)
      end
    end
    # load user specific domination data
    domination_configurations.each do |conf|
      c.set_cstr_list("dominate", conf.dominator.name, conf.dominated_features.map(&:name))
    end
    # load collapsing configuration
    if collapsing_configuration
      c.set_cstr_list("collapse", "to_parent", collapsing_configuration.to_parent)
    end
    return c
  end
    
end
