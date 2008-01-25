module Config::Dominations

  def config_dominations
    user = User.find(session[:user])
    @dominations = DominationConfiguration.defaults
    user.domination_configurations.each do |conf|
      @dominations[conf.dominator.name] = conf.dominated_features.map(&:name)
    end    
    @not_dominating = 
     FeatureClass.find(:all).delete_if do |fc| 
       @dominations.keys.include? fc.name
      end
  end 
        
  def reset_dominations
    user = User.find(session[:user])
    user.domination_configurations.destroy_all
    redirect_to :action => :config_dominations
  end    

  def manage_dominated
    user = User.find(session[:user])
    redirect_to :action => :config_dominations    
  end
  
end