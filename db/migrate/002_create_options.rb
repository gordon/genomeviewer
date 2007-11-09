class CreateOptions < ActiveRecord::Migration
  def self.up
    create_table :options do |t|
     t.column :somedata, :string, :limit => 16
     t.column :user_id, :integer
    end
  end

  def self.down
    drop_table :options
  end
end
