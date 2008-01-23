class CreateFeatureStyleConfigurations < ActiveRecord::Migration
  def self.up
    create_table :feature_style_configurations do |t|
      t.belongs_to :user
      t.string :feature
      t.string :style
    end
  end

  def self.down
    drop_table :feature_style_configurations
  end
end
