class SeparateConfigurationFromUser < ActiveRecord::Migration
  
  def self.up
    create_table :configurations do |t|
      t.belongs_to :user
      t.integer :width, :default => 800, :null => false
    end
    remove_column :formats, :width
    add_column :formats, :configuration_id, :integer, :default => nil
    Format.reset_column_information
    Format.find(:all).each do |f|
      f.update_attributes(:configuration_id => Configuration.create(:user_id => f.user_id))
    end
    remove_column :formats, :user_id
    remove_column :feature_types, :user_id
    add_column :feature_types, :configuration_id, :integer, :default => nil
  end
  
  def self.down
    remove_column :feature_types, :configuration_id
    add_column :feature_types, :user_id, :integer
    add_column :formats, :user_id, :integer
    remove_column :formats, :configuration_id
    add_column :formats, :width, :integer, :default => 800
    drop_table :configurations
  end
  
end