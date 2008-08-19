class FormatController < ApplicationController
  
  before_filter :enforce_login

  active_scaffold :format do |config|
    config.label = "General settings"
    config.columns = Format.configuration_attributes
    Format.configuration_attributes.each do |c|
      config.columns[c].sort = false
    end
    [:create, :search, :new, :delete, :show].each do |act|
      config.actions.exclude act
    end

  end
  
  def conditions_for_collection
    ["configuration_id = ?", @current_user.configuration.id]
  end
  
  def before_update_save(record)
    record.upload
  end
  
end