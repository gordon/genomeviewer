class CreateAnnotations < ActiveRecord::Migration
  def self.up
    create_table :annotations do |t|
      t.string :name, :null => false
      t.belongs_to :user, :null => false
      t.text :description
      t.boolean :public, :null => false, :default => false
      t.boolean :add_introns, :null => false, :default => true 
    end
  end

  def self.down
    drop_table :annotations
  end
end
