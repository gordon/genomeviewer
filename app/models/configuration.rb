class Configuration < ActiveRecord::Base
  
  belongs_to :user  
  has_many :feature_types, :dependent => :destroy 
  has_one  :format, :dependent => :destroy

  after_save :default_format
  after_create :uncache
  
  def default_format
    unless Format.find_by_configuration_id(self[:id])
     f = Format.default_new
     f.configuration_id = self[:id]
     f.save
    end
  end

  # pointer to the gt_ruby GT::Config object in the DRb server
  def gt
    GTServer.config(config_key)
  end

  def uncache
    GTServer.config_uncache(@key)
    @key = nil
  end

  def self.default
    GTServer.config_default
  end

  def config_key
    @key ||= (self[:id] || self.object_id)
  end

end