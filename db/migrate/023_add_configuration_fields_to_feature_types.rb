class AddConfigurationFieldsToFeatureTypes < ActiveRecord::Migration

  def self.up
    
    # meaning of undefined: 50% gray 
    # see libgtview/config.c config_get_color
    
    add_column :feature_types, :fill_red, :decimal, :default => nil
    add_column :feature_types, :fill_green, :decimal, :default => nil
    add_column :feature_types, :fill_blue, :decimal, :default => nil
                                           
    add_column :feature_types, :stroke_red, :decimal, :default => nil
    add_column :feature_types, :stroke_green, :decimal, :default => nil
    add_column :feature_types, :stroke_blue, :decimal, :default => nil
    
    add_column :feature_types, :stroke_marked_red, :decimal, :default => nil
    add_column :feature_types, :stroke_marked_green, :decimal, :default => nil
    add_column :feature_types, :stroke_marked_blue, :decimal, :default => nil
    
    # meaning of undefined: box
    # see libgtview/canvas.c canvas_visit_element
    add_column :feature_types, :style_key, :integer, :default => nil
    
    # meaning of undefined: false
    # see libgtview/diagram.c process_node
    add_column :feature_types, :collapse_to_parent, :boolean, :default => nil
    
    # meaning of undefined: true 
    # see libgtview/diagram.c collect_blocks
    add_column :feature_types, :split_lines, :boolean, :default => nil
    
    # meaning of undefined: see libgtview/diagram.c get_caption_display_status 
    add_column :feature_types, :max_capt_show_width, :integer, :default => nil
    add_column :feature_types, :max_num_lines, :integer, :default => nil

  end

  def self.down
    remove_column :feature_types, :fill_red
    remove_column :feature_types, :fill_green
    remove_column :feature_types, :fill_blue
    remove_column :feature_types, :stroke_red
    remove_column :feature_types, :stroke_green
    remove_column :feature_types, :stroke_blue
    remove_column :feature_types, :stroke_marked_red
    remove_column :feature_types, :stroke_marked_green
    remove_column :feature_types, :stroke_marked_blue
    remove_column :feature_types, :style_key
    remove_column :feature_types, :collapse_to_parent
    remove_column :feature_types, :split_lines
    remove_column :feature_types, :max_capt_show_width
    remove_column :feature_types, :max_num_lines
  end
  
end
