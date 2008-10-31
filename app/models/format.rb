class Format < ActiveRecord::Base
  include GTRubyConfigurator

  belongs_to :configuration

  set_section "format"
  set_colors :track_title_color, :default_stroke_color
  set_bools :show_grid
  set_decimals :margins, :bar_height, :bar_vspace, :track_vspace,
         :scale_arrow_width, :scale_arrow_height, :arrow_width,
         :stroke_width, :stroke_marked_width, :min_len_block

  delegate :width, :to => :configuration
  delegate :width=, :to => :configuration

  def self.helptext(attribute_name)
    case attribute_name.to_sym
      when :width : "default width of the image (px)"
      when :margins : "space left and right of diagram (px)"
      when :bar_height : "height of a feature bar (px)"
      when :bar_vspace : "space between feature bars (px)"
      when :track_vspace : "space between tracks (px)"
      when :scale_arrow_width : "width of scale arrowheads (px)"
      when :scale_arrow_height : "height of scale arrowheads (px)"
      when :arrow_width : "width of feature arrowheads (px)"
      when :stroke_width : "width of outlines (px)"
      when :stroke_marked_width : "width of outlines for marked elements (px)"
      when :show_grid : "show light vertical lines for orientation?"
      when :min_len_block : "minimum length of a block in which single elements are shown (nt)"
      when :track_title_color : "color of the track title"
      when :default_stroke_color : "default stroke color"
      else
	      ""
    end
  end

end
