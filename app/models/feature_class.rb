class FeatureClass < ActiveRecord::Base

  has_many :color_configurations, :as => :element
  validates_uniqueness_of :name

end
