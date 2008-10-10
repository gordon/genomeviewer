#
# This controller is responsible for an active_scaffold
# (see vendor/plugins/active_scaffold) that is embedded 
# in the configuration page.
#
class FeatureTypesController < ApplicationController
  
  before_filter :enforce_login
  
  #
  # declaration and configuration of the scaffold
  #
  active_scaffold :feature_types do |config|
    
    # the columns array is built dinamically, using the lists
    # provided by the FeatureType model
    config.columns = [:name] + FeatureType.configuration_attributes
    
    # allow sorting of the aggregates' columns:
    FeatureType.list_colors.each do |c| 
      config.columns[c].sort_by :sql => "#{c}_red, #{c}_green, #{c}_blue"
    end
    FeatureType.list_styles.each do |s|
      config.columns[s].sort_by :sql => "#{s}_key"
    end
    
  end

private

  def conditions_for_collection
    # show only current_user's settings
    ["configuration_id = ?", @current_user.configuration.id]
  end
  
  def before_save(record)
    record.upload
  end
  alias_method :before_update_save, :before_save
  alias_method :before_create_save, :before_save
  
end
