class CreateDrawingFormatConfigurations < ActiveRecord::Migration
  def self.up
    create_table :drawing_format_configurations do |t|
    
    end
  end

  def self.down
    drop_table :drawing_format_configurations
  end
end