class FeatureType < ActiveRecord::Base

  belongs_to :user
  validates_uniqueness_of :name, :scope => :user_id
  composed_of :style, :mapping => ["style_key","key"] do |n| 
    Style.new(n) 
  end

end
