class FeatureType < ActiveRecord::Base

  belongs_to :configuration
  validates_uniqueness_of :name, :scope => :configuration_id
  composed_of :style, :mapping => ["style_key","key"] do |n| 
    Style.new(n) 
  end

end
