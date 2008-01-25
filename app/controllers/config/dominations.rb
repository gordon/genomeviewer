module Config::Dominations

  def config_dominations
    user = User.find(session[:user])
    @dominations = DominationConfiguration.defaults
    # override defaults with user specific information
    user.domination_configurations.each do |conf|
      @dominations[conf.dominating.name] ||= []
      @dominations[conf.dominating.name] << conf.dominated.name
      @dominations[conf.dominating.name].uniq!
    end
  end
  
end