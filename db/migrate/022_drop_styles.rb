class DropStyles < ActiveRecord::Migration
  
  def self.up
    drop_table :styles
  end
  
  def self.down
    create_table :styles do |t|
      t.string :name
    end
  end
  
end
