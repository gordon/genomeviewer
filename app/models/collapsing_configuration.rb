class CollapsingConfiguration < ActiveRecord::Base
  
  serialize :to_parent, Array
  
  # returns the default value as array
  # reads it from view.lua using gtruby
  def self.default    
    c = GT::Config.new
    c.load_file("config/view.lua")
    return c.get_cstr_list("collapse","to_parent").to_a
  end
  
end
