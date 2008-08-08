class Configuration < ActiveRecord::Base
  
  belongs_to :user  
  has_many :feature_types, :dependent => :destroy 
  has_one  :format, :dependent => :destroy

  after_save :default_format
  
  def default_format
    Format.find_or_create_by_configuration_id(self[:id])
  end

  # pointer to the gt_ruby GT::Config object in the DRb server
  def gt
    # not implemented yet
  end
  
end