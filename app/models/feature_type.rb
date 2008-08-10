class FeatureType < ActiveRecord::Base
  
  include GTRubyConfigurator
  set_section { self.name }
  set_colors :fill, :stroke, :stroke_marked
  set_bools :collapse_to_parent, :split_lines
  set_integers :max_capt_show_width, :max_num_lines
  set_style :style

  belongs_to :configuration
  validates_uniqueness_of :name, :scope => :configuration_id
  
  #
  # returns a new object with all attributes set to the default
  #
  def self.default_new(name)
    instance = new(:name => name)
    configuration_attributes.each do |attr|
      instance.send("#{attr}=", instance.send("default_#{attr}"))
    end
    instance
  end

end
