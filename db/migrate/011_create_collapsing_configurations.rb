class CreateCollapsingConfigurations < ActiveRecord::Migration
  def self.up
    create_table :collapsing_configurations do |t|
      t.belongs_to :user
      t.text :to_parent 
    end
  end

  def self.down
    drop_table :collapsing_configurations
  end
end
