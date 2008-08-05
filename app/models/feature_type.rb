class FeatureType < ActiveRecord::Base

  belongs_to :user
  validates_uniqueness_of :name, :scope => :user_id
  named_scope :global, :conditions => {:user_id => nil}

end
