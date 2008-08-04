class AddMinLenBlockToDrawingFormatConfigurations < ActiveRecord::Migration

  def self.up
    add_column :drawing_format_configurations, :min_len_block, :decimal, :default => 40
  end
  
  def self.down
    remove_column :drawing_format_configurations, :min_len_block
  end

end