class CreateSequenceRegions < ActiveRecord::Migration
  def self.up
    create_table :sequence_regions do |t|
     t.string :seq_id, :null => false
     t.belongs_to :annotation, :null => false
     t.integer :seq_begin, :null => false
     t.integer :seq_end, :null => false
     t.text :description
    end
  end

  def self.down
    drop_table :sequence_regions
  end
end
