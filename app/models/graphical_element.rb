class GraphicalElement < ActiveRecord::Base

  has_many :color_configurations, :as => :element
  
end
