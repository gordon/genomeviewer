class CollapsingConfiguration < ActiveRecord::Base

  serialize :to_parent, Array

  # returns the default value as array
  # reads it from view.lua using gtruby
  def self.default
    c = GTServer.default_config_object
    return c.get_cstr_list("collapse","to_parent").to_a
  end

end
