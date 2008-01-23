class ColorConfiguration < ActiveRecord::Base
  
  belongs_to :element, :polymorphic => true
  belongs_to :user
  
end
