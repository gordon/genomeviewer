#
# This controller is responsible for an active_scaffold
# (see vendor/plugins/active_scaffold) that is embedded 
# in the configuration page.
#
class FormatController < ApplicationController
  
  before_filter :enforce_login

  #
  # declaration and configuration of the scaffold
  #
  active_scaffold :format do |config|
    config.label = "General settings"
    
    # the columns array is built dinamically, using the lists
    # provided by the FeatureType model
    columns = [:width] + Format.configuration_attributes
    
    config.columns = columns
    config.columns[:width].label = "Default width"
    
    columns.each do |c|
      # disable sorting, as there is only 1 record
      config.columns[c].sort = false
      # show an help text for each column
      config.columns[c].description = Format.helptext(c)
    end
    # exclude unnecessary actions (increasing security)
    [:create, :search, :new, :delete, :show].each do |act|
      config.actions.exclude act
    end

  end

private

  #
  # show only current_user's record in list
  #
  def conditions_for_collection
    ["configuration_id = ?", @current_user.configuration.id]
  end
  
  #
  # upload configuration changes in the gtserver 
  # and save width
  #
  def before_update_save(record)
    record.upload
    record.configuration.save # to save the width
  end
  
  #
  # records should be edited only by their owner
  #
  def own_record?
    record_owner = Format.find(params["id"]).configuration.user
    redirect_to logout_url unless record_owner == current_user
  end
  alias_method :update_authorized?, :own_record?
  
end