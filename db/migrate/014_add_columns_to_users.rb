class AddColumnsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :institution, :string
    add_column :users, :url, :string
  end

  def self.down
    remove_column :users, :institution
    remove_column :users, :url
  end
end
