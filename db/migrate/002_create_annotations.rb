class CreateAnnotations < ActiveRecord::Migration
  def self.up
    create_table :annotations do |t|
      t.column :path, :string, :null => false
      t.column :filename, :string, :null => false
      t.column :user_id, :int, :null => false
      t.column :description, :text
      t.column :public, :boolean, :null => false, :default => false
    end
  end

  def self.down
    drop_table :annotations
  end
end
