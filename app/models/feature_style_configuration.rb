class FeatureStyleConfiguration < ActiveRecord::Base

  belongs_to :user
  belongs_to :style
  belongs_to :feature_class
  
  # returns an hash with the default values from view.lua
  def self.defaults
    c = GTServer.new_config_object
    c.load_file(File.expand_path("config/view.lua"))
    styles = {}
    # as there is no iterator yet in gtruby try all features 
    FeatureClass.find(:all).map(&:name).each do |f| 
      f_style = c.get_cstr("feature_styles",f)
      styles[f] = f_style unless f_style == "undefined"
    end
    return styles
  end

end
