class CreateUuidLogs < ActiveRecord::Migration
  
  #
  # This table is a temporary storage;
  # older records may and should be deleted 
  # every x minutes or seconds
  #
  def self.up
    create_table :uuid_logs do |t|
      t.string   :uuid, :limit => 36
      t.text     :args
      t.datetime :created_at
    end
    add_index :uuid_logs, :uuid
    add_index :uuid_logs, :created_at
  end
  
  def self.down
    drop_table :uuid_logs
  end
end