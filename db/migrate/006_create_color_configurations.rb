class CreateColorConfigurations < ActiveRecord::Migration
  def self.up
    create_table :color_configurations do |t|
      t.belongs_to :user
      t.references :element, :polymorphic => true
      t.decimal :red
      t.decimal :green
      t.decimal :blue
    end
  end

  def self.down
    drop_table :color_configurations
  end 
end
