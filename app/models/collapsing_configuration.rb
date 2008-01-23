class CollapsingConfiguration < ActiveRecord::Base
  
  serialize :to_parent, Array
  
end
