class CreateDominationConfigurations < ActiveRecord::Migration
  def self.up
    create_table :domination_configurations do |t|
      t.belongs_to :user
      t.text :collapse
      t.text :dominate
    end 
  end 

  def self.dow
    drop_table :domination_configurations
  end
end
