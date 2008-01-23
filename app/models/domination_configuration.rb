class DominationConfiguration < ActiveRecord::Base

  belongs_to :user
  belongs_to :dominated, :class => "FeatureClass"
  belongs_to :dominating, :class => "FeatureClass"
  
end
