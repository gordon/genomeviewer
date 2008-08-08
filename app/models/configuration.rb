class Configuration < ActiveRecord::Base
  
  belongs_to :user  
  has_many :feature_types, :dependent => :destroy
  has_one  :format, :dependent => :destroy

  # pointer to the gt_ruby GT::Config object in the DRb server
  def gt
    # not implemented yet
  end
  
end