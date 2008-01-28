class DrawingFormatConfiguration < ActiveRecord::Base
  
  belongs_to :user
  
  # list of attribute names that have a value expressed in pixel 
  def pixel_attribute_names
    attribute_names - ["id","user_id","show_grid"]
  end
  
  def self.helptext(attribute_name)
    case attribute_name
      when "width" : "(desired image width)"
      when "margins" : "(space left and right of diagram)"
      when "bar_height" : "(height of a feature bar)"
      when "bar_vspace" : "(space between feature bars)"
      when "track_vspace" : "(space between tracks)"
      when "scale_arrow_width" : "(width of scale arrowheads)"
      when "scale_arrow_height" : "(height of scale arrowheads)"
      when "arrow_width" : "(width of feature arrowheads)"
      when "stroke_width" : "(width of outlines)"
      when "stroke_marked_width" : "(width of outlines for marked elements)"
      when "show_grid" : "(shows light vertical lines for orientation)"
      else
	""
    end
  end
  
end
