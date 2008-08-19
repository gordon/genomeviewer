class AddConfigFieldsToFeatureTypeInAnnotations < ActiveRecord::Migration
  
  def self.up
    remove_column :feature_type_in_annotations, :show
    add_column :feature_type_in_annotations, :max_show_width, :integer, :default => nil
    add_column :feature_type_in_annotations, :max_capt_show_width, :integer, :default => nil
  end
  
  def self.down
    add_column :feature_type_in_annotations, :show, :integer, :default => true, :null => false
    remove_column :feature_type_in_annotations, :max_show_width
    remove_column :feature_type_in_annotations, :max_capt_show_width
  end
  
end