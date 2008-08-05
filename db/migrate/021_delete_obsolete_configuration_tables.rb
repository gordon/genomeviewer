class DeleteObsoleteConfigurationTables < ActiveRecord::Migration

  def self.up
    drop_table :graphical_elements
    drop_table :color_configurations
    drop_table :domination_configurations
    drop_table :collapsing_configurations
    drop_table :dominated_features
    drop_table :feature_style_configurations
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end

end