class FeatureStyleConfiguration < ActiveRecord::Base

  belongs_to :user
  belongs_to :style
  belongs_to :feature_class

end
