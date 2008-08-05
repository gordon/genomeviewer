class RenameDrawingFormatConfigurationsInFormats < ActiveRecord::Migration

  def self.up
    rename_table :drawing_format_configurations, :formats
  end
  
  def self.down
    rename_table :formats, :drawing_format_configurations
  end

end