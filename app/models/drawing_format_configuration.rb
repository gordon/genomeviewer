class DrawingFormatConfiguration < ActiveRecord::Base
  
  belongs_to :user
  
  # list of attribute names that have a value expressed in pixel 
  def pixel_attribute_names
    attribute_names - ["id","user_id","show_grid"]
  end
  
end
