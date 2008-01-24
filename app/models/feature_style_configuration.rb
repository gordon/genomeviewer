class FeatureStyleConfiguration < ActiveRecord::Base

  belongs_to :user
  belongs_to :style
  belongs_to :feature_class
  
  # returns an hash with the default values from view.lua
  def self.defaults
    c = GT::Config.new
    c.load_file("config/view.lua")
    styles = {}
    # as there is no iterator yet in gtruby try all features 
    FeatureClass.find(:all).map(&:name).each do |f| 
      f_style = c.get_cstr("feature_styles",f)
      styles[f] = f_style unless f_style == "undefined"
    end
    return styles
  end

end
