module Config::Collapse

  def config_collapse
    user = User.find(session[:user])
    @collapse = 
      if user.collapsing_configuration
        user.collapsing_configuration.to_parent 
      else 
        CollapsingConfiguration.default
      end
  end

end