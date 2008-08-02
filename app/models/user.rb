class User < ActiveRecord::Base

  ### associations ###
  has_many :annotations, :dependent => :destroy
  # user specific feature classes:
  has_many :own_feature_classes, :class_name => "FeatureClass", :dependent => :destroy
  
  def feature_classes
    FeatureClass.global+own_feature_classes
  end

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
    Dir.mkdir "#{$GFF3_STORAGE_PATH}/#{self[:id]}"
  end
  
  def destroy_storage
    Dir.rmdir "#{$GFF3_STORAGE_PATH}/#{self[:id]}"
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
                         configuration files public default in_session 
                         own_annotations public_annotations public_users 
                         register image move],
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

  # returns the (eventually cached) GT::Config object 
  # with the personalisations for this user
  def config
    cached = GTServer.cached_config_for?(self[:id])
    c = GTServer.config_object_for_user(self[:id])
    unless cached
      # load user specific configurations
      load_user_colors_in(c)
      load_user_styles_in(c)
      load_user_formats_in(c)
      load_user_dominates_in(c)
      load_user_collapses_in(c)
    end
    return c
  end
  
  def flush_config_cache
    GTServer.config_object_for_user(self[:id], :delete_cache => true)
  end

  private

  ### helper functions for config ###

  def load_user_colors_in(config_object)
    color_configurations.each do |conf|
      color = GTServer.new_color_object
      color.red = conf.red.to_f
      color.green = conf.green.to_f
      color.blue = conf.blue.to_f
      config_object.set_color(conf.element.name, color)
    end
  end

  def load_user_styles_in(config_object)
    feature_style_configurations.each do |record|
      config_object.set_cstr("feature_styles",
                             record.feature_class.name,
                             record.style.name)
    end
  end

  def load_user_formats_in(config_object)
    return unless drawing_format_configuration
    dfc = drawing_format_configuration
    # set show_grid
    show_grid = dfc.show_grid ? "yes" : "no"
    config_object.set_cstr("format",
                           "show_grid",
                           show_grid)
    # set all other format attributes
    dfc.pixel_attribute_names.each do |attr|
      c.set_num("format",
                attr,
                dfc.send(attr).to_f)
    end
  end

  def load_user_dominates_in(config_object)
    domination_configurations.each do |conf|
      unless conf.dominated_features.empty?
        dfs = conf.dominated_features.map(&:feature_class).map(&:name)
        config_object.set_cstr_list("dominate",
                                    conf.dominator.name,
                                    dfs)
      else
        config_object.set_cstr_list("dominate", conf.dominator.name, [])
      end
    end
  end

  def load_user_collapses_in(config_object)
    return unless collapsing_configuration
    config_object.set_cstr_list("collapse",
                                "to_parent",
                                collapsing_configuration.to_parent)
  end

end
