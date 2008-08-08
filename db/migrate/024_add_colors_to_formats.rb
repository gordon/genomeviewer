class AddColorsToFormats < ActiveRecord::Migration
  
  def self.up
    change_column :formats, :margins,                    :decimal, :default => nil
    change_column :formats, :bar_height,                 :decimal, :default => nil
    change_column :formats, :bar_vspace,                 :decimal, :default => nil
    change_column :formats, :track_vspace,               :decimal, :default => nil
    change_column :formats, :scale_arrow_width,          :decimal, :default => nil
    change_column :formats, :scale_arrow_height,         :decimal, :default => nil
    change_column :formats, :arrow_width,                :decimal, :default => nil
    change_column :formats, :stroke_width,               :decimal, :default => nil
    change_column :formats, :stroke_marked_width,        :decimal, :default => nil
    change_column :formats, :show_grid,                  :boolean, :default => nil
    change_column :formats, :min_len_block,              :decimal, :default => nil
    add_column    :formats, :track_title_color_red,      :decimal, :default => nil
    add_column    :formats, :track_title_color_green,    :decimal, :default => nil
    add_column    :formats, :track_title_color_blue,     :decimal, :default => nil
    add_column    :formats, :default_stroke_color_red,   :decimal, :default => nil
    add_column    :formats, :default_stroke_color_green, :decimal, :default => nil
    add_column    :formats, :default_stroke_color_blue,  :decimal, :default => nil
  end
  
  def self.down
    change_column :formats, :margins,                    :decimal, :default => 30.0
    change_column :formats, :bar_height,                 :decimal, :default => 15.0
    change_column :formats, :bar_vspace,                 :decimal, :default => 10.0
    change_column :formats, :track_vspace,               :decimal, :default => 10.0
    change_column :formats, :scale_arrow_width,          :decimal, :default => 6.0
    change_column :formats, :scale_arrow_height,         :decimal, :default => 10.0
    change_column :formats, :arrow_width,                :decimal, :default => 6.0
    change_column :formats, :stroke_width,               :decimal, :default => 0.5
    change_column :formats, :stroke_marked_width,        :decimal, :default => 1.5
    change_column :formats, :show_grid,                  :boolean, :default => true
    change_column :formats, :min_len_block,              :decimal, :default => 40.0
    remove_column :formats, :track_title_color_red
    remove_column :formats, :track_title_color_green
    remove_column :formats, :track_title_color_blue
    remove_column :formats, :default_stroke_color_red
    remove_column :formats, :default_stroke_color_green
    remove_column :formats, :default_stroke_color_blue
  end
  
end