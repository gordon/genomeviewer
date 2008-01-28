class DrawingFormatConfiguration < ActiveRecord::Base
  
  belongs_to :user
  
  # list of attribute names that have a value expressed in pixel 
  def pixel_attribute_names
    attribute_names - ["id","user_id","show_grid"]
  end
  
  def self.helptext(attribute_name)
    case attribute_name
      when "width" : "desired image width in pixel"
      when "margins" : "space left and right of diagram, in pixels"
      when "bar_height" : "height of a feature bar, in pixels"
      when "bar_vspace" : "space between feature bars, in pixels"
      when "track_vspace" : "space between tracks, in pixels"
      when "scale_arrow_width" : "width of scale arrowheads, in pixels"
      when "scale_arrow_height" : "height of scale arrowheads, in pixels"
      when "arrow_width" : "width of feature arrowheads, in pixels"
      when "stroke_width" : "width of outlines, in pixels"
      when "stroke_marked_width" : "width of outlines for marked elements, in pixels"
      when "show_grid" : "shows light vertical lines for orientation"
      else
	""
    end
  end
  
end
