class CreateSequenceRegions < ActiveRecord::Migration
  def self.up
    create_table :sequence_regions do |t|
     t.column :seq_id, :string, :null => false
     t.column :annotation_id, :int, :null => false
     t.column :seq_begin, :int, :null => false
     t.column :seq_end, :int, :null => false
     t.column :description, :text
    end
  end

  def self.down
    drop_table :sequence_regions
  end
end
