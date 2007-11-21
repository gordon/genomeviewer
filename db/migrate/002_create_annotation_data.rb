class CreateAnnotationData < ActiveRecord::Migration
  def self.up
    create_table :annotation_data do |t|
     t.column :datasource, :string, :null => false
     t.column :user_id, :int, :null => false
     t.column :description, :text
     t.column :public, :boolean, :null => false, :default => false
    end
  end

  def self.down
    drop_table :annotation_data
  end
end
