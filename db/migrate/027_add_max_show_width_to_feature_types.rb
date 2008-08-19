class AddMaxShowWidthToFeatureTypes < ActiveRecord::Migration

  def self.up
    add_column :feature_types, :max_show_width, :integer, :default => nil
  end
  
  def self.down
    remove_column :feature_types, :max_show_width
  end

end