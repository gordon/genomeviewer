class Configuration < ActiveRecord::Base
  
  belongs_to :user  
  has_many :feature_types, :dependent => :destroy 
  has_one  :format, :dependent => :destroy

  after_save :default_format
  after_create :flush_cache
  
  def default_format
    unless Format.find_by_configuration_id(self[:id])
     f = Format.default_new
     f.configuration_id = self[:id]
     f.save
    end
  end

  # pointer to the gt_ruby GT::Config object in the DRb server
  def gt
    GTServer.config_object_for_user(user_id)
  end

  def flush_cache
    GTServer.config_object_for_user(user_id, :delete_cache => true)
  end

  def self.default
    GTServer.default_config_object
  end

end