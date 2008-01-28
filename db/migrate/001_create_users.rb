class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
     t.string :password, :limit => 40, :null => false
     t.string :name, :limit => 64, :null => false
     t.string :email, :limit => 64, :null => false
    end
  end

  def self.down
    drop_table :users
  end
end
