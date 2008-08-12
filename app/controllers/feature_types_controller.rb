class FeatureTypesController < ApplicationController
  
  before_filter :enforce_login
  
  active_scaffold :feature_types do |config|
    config.columns = [:name] + FeatureType.configuration_attributes
    FeatureType.list_colors.each do |c| 
      config.columns[c].sort_by :sql => "#{c}_red, #{c}_green, #{c}_blue"
    end
  end
  
  def conditions_for_collection
    ["configuration_id = ?", @current_user.configuration.id]
  end
  
end