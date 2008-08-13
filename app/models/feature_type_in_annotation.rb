class FeatureTypeInAnnotation < ActiveRecord::Base
  
  belongs_to :annotation
  belongs_to :feature_type
  
end
