class CreateOptions < ActiveRecord::Migration
  def self.up
    create_table :options do |t|
    end
  end

  def self.down
    drop_table :options
  end
end
