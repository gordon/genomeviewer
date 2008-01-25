class CreateDominationConfigurations < ActiveRecord::Migration
  def self.up
    create_table :domination_configurations do |t|
      t.belongs_to :user
      t.references :dominator
    end 
  end 

  def self.dow
    drop_table :domination_configurations
  end
end
