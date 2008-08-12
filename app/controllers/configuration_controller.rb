class ConfigurationController < ApplicationController
  
  before_filter :enforce_login
  append_before_filter :title
  
  def title
    @title = "Configuration"
  end
  
end