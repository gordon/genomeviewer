class CreateDrawingFormatConfigurations < ActiveRecord::Migration
  def self.up
    create_table :drawing_format_configurations do |t|
      t.decimal :margins , :default => 30      # space left and right of diagram, in pixels
      t.decimal :bar_height , :default => 15   # height of a feature bar, in pixels
      t.decimal :bar_vspace , :default => 10   # space between feature bars, in pixels
      t.decimal :track_vspace , :default => 10 # space between tracks, in pixels
      t.decimal :scale_arrow_width , :default => 6     # width of scale arrowheads, in pixels
      t.decimal :scale_arrow_height , :default => 10   # height of scale arrowheads, in pixels
      t.decimal :arrow_width , :default => 6   # width of feature arrowheads, in pixels
      t.decimal :stroke_width , :default => 0.5 # width of outlines, in pixels
      t.decimal :stroke_marked_width , :default => 1.5 # width of outlines for marked elements, in pixels
      t.boolean :show_grid , :default => true # shows light vertical lines for orientation
    end
  end

  def self.down
    drop_table :drawing_format_configurations
  end
end
