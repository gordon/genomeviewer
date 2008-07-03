class DominatedFeature < ActiveRecord::Base

  belongs_to :domination_configuration
  belongs_to :feature_class

end
