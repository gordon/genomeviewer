class FeatureType < ActiveRecord::Base

  has_many :color_configurations, :as => :element
  belongs_to :user
  validates_uniqueness_of :name, :scope => :user_id
  named_scope :global, :conditions => {:user_id => nil}

end
