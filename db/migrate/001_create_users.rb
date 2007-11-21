class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
     t.column :password, :string, :limit => 40, :null => false
     t.column :name, :string, :limit => 64, :null => false
     t.column :email, :string, :limit => 64, :null => false
    end
  end

  def self.down
    drop_table :users
  end
end
