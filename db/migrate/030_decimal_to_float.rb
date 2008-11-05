class DecimalToFloat < ActiveRecord::Migration
  def self.up
    change_column :feature_types, :fill_red, :float
    change_column :feature_types, :fill_green, :float
    change_column :feature_types, :fill_blue, :float
    change_column :feature_types, :stroke_red, :float
    change_column :feature_types, :stroke_green, :float
    change_column :feature_types, :stroke_blue, :float
    change_column :feature_types, :stroke_marked_red, :float
    change_column :feature_types, :stroke_marked_green, :float
    change_column :feature_types, :stroke_marked_blue, :float
    change_column :formats, :margins, :float
    change_column :formats, :bar_height, :float
    change_column :formats, :bar_vspace, :float
    change_column :formats, :track_vspace, :float
    change_column :formats, :scale_arrow_width, :float
    change_column :formats, :scale_arrow_height, :float
    change_column :formats, :arrow_width, :float
    change_column :formats, :stroke_width, :float
    change_column :formats, :stroke_marked_width, :float
    change_column :formats, :min_len_block, :float
    change_column :formats, :track_title_color_red, :float
    change_column :formats, :track_title_color_green, :float
    change_column :formats, :track_title_color_blue, :float
    change_column :formats, :default_stroke_color_red, :float
    change_column :formats, :default_stroke_color_green, :float
    change_column :formats, :default_stroke_color_blue, :float
  end

  def self.down
    change_column :feature_types, :fill_red, :decimal
    change_column :feature_types, :fill_green, :decimal
    change_column :feature_types, :fill_blue, :decimal
    change_column :feature_types, :stroke_red, :decimal
    change_column :feature_types, :stroke_green, :decimal
    change_column :feature_types, :stroke_blue, :decimal
    change_column :feature_types, :stroke_marked_red, :decimal
    change_column :feature_types, :stroke_marked_green, :decimal
    change_column :feature_types, :stroke_marked_blue, :decimal
    change_column :formats, :margins, :decimal
    change_column :formats, :bar_height, :decimal
    change_column :formats, :bar_vspace, :decimal
    change_column :formats, :track_vspace, :decimal
    change_column :formats, :scale_arrow_width, :decimal
    change_column :formats, :scale_arrow_height, :decimal
    change_column :formats, :arrow_width, :decimal
    change_column :formats, :stroke_width, :decimal
    change_column :formats, :stroke_marked_width, :decimal
    change_column :formats, :min_len_block, :decimal
    change_column :formats, :track_title_color_red, :decimal
    change_column :formats, :track_title_color_green, :decimal
    change_column :formats, :track_title_color_blue, :decimal
    change_column :formats, :default_stroke_color_red, :decimal
    change_column :formats, :default_stroke_color_green, :decimal
    change_column :formats, :default_stroke_color_blue, :decimal
  end
end
