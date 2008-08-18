class FeatureType < ActiveRecord::Base
  include GTRubyConfigurator
  
  set_section { self.name }
  set_colors :fill, :stroke, :stroke_marked
  set_bools :collapse_to_parent, :split_lines
  set_integers :max_capt_show_width, :max_num_lines
  set_styles :style

  belongs_to :configuration
  has_many :feature_type_in_annotations
  has_many :annotations, :through => :feature_type_in_annotations
  validates_uniqueness_of :name, :scope => :configuration_id
  
end
