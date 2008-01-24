class DominationConfiguration < ActiveRecord::Base

  belongs_to :user
  belongs_to :dominated, :class_name => "FeatureClass"
  belongs_to :dominating, :class_name => "FeatureClass"
  
  # returns the default values from view.lua
  def self.defaults
    c = GT::Config.new
    c.load_file("config/view.lua")
    dominations = {}
    # as there is no iterator yet in gtruby try all features 
    FeatureClass.find(:all).map(&:name).each do |f| 
      dominated = c.get_cstr_list("dominate",f).to_a
      dominations[f] = dominated unless dominated.empty?
    end
    return dominations
  end
  
end
