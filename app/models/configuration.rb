class Configuration < ActiveRecord::Base
  
  belongs_to :user  
  has_many :feature_types, :dependent => :destroy 
  has_one  :format, :dependent => :destroy
  
  def section_objects
    [format]+feature_types
  end  
  
  def sections
    section_objects.map(&:section)
  end

  after_save       :default_format
  after_create     :uncache
  
  def default_format
    unless Format.find_by_configuration_id(self[:id])
     f = Format.default_new
     f.configuration_id = self[:id]
     f.save
    end
  end

  # reference to the GT::Config object 
  # corresponding to this object
  #
  # if there is no cache, upload all setting
  # from the DB into the gt config object
  # but allow an exception to avoid circular 
  # references
  #
  def gt(upload_exception_section = nil, upload_exception_attr = nil)
    if !GTServer.config_cached?(self[:id])
      GTServer.config(self[:id])
      section_objects.each do |x|
        if x.section == upload_exception_section
          x.upload_except(upload_exception_attr)
        else
          x.upload
        end
      end
    end
    GTServer.config(self[:id])
  end
  
  def uncache
    GTServer.config_uncache(self[:id])
  end

  def self.default
    GTServer.config_default
  end

end