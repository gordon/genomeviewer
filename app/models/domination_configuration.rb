class DominationConfiguration < ActiveRecord::Base

  belongs_to :user
  belongs_to :dominated, :class_name => "FeatureClass"
  belongs_to :dominating, :class_name => "FeatureClass"
  
end
