class CreateAnnotations < ActiveRecord::Migration
  def self.up
    create_table :annotations do |t|
     t.column :seq_id, :string, :null => false
     t.column :annotation_data_id, :int, :null => false
     t.column :seq_begin, :int, :null => false
     t.column :seq_end, :int, :null => false
     t.column :description, :text
    end
  end

  def self.down
    drop_table :annotations
  end
end
