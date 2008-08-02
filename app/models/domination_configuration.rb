class DominationConfiguration < ActiveRecord::Base

  belongs_to :user
  belongs_to :dominator, :class_name => "FeatureClass"
  has_many :dominated_features, :dependent => :destroy

  # returns the default values from view.lua
  def self.defaults_for(user)
    c = GTServer.default_config_object
    dominations = {}
    # as there is no iterator in gtruby try all features
    user.feature_classes.map(&:name).each do |f|
      dominated = c.get_cstr_list("dominate",f).to_a
      dominations[f] = dominated unless dominated.empty?
    end
    return dominations
  end

end
