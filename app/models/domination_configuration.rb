class DominationConfiguration < ActiveRecord::Base

  belongs_to :user
  belongs_to :dominator, :class_name => "FeatureClass"
  has_many :dominated_features, :dependent => :destroy
  
  # returns the default values from view.lua
  def self.defaults
    c = GTSvr.getConfigObject
    c.load_file(File.expand_path("config/view.lua"))
    dominations = {}
    # as there is no iterator yet in gtruby try all features 
    FeatureClass.find(:all).map(&:name).each do |f| 
      dominated = c.get_cstr_list("dominate",f).to_a
      dominations[f] = dominated unless dominated.empty?
    end
    return dominations
  end
  
end
