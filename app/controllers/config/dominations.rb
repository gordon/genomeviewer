module Config::Dominations

  def config_dominations
    user = User.find(session[:user])
    fcs = FeatureClass.find(:all)
    defaults = DominationConfiguration.defaults
    @dominations = {}
    fcs.each do |fc|
      user.domination_configurations.for(fc.name).each do |dominated_by_fc|
        
      end
    end
    @dominations = 
      if user.dominations.empty?
        DominationConfiguration.defaults
      else
        user.dominations
      end
    # override defaults with user specific information
    user.domination_configurations.each do |conf|
      @dominations[conf.dominating.name] ||= []
      @dominations[conf.dominating.name] << conf.dominated.name
      @dominations[conf.dominating.name].uniq!
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
    @dominating = FeatureClass.find_by_name(params[:dominating])
    @dominated = DominationConfiguration.defaults[params[:dominating]]
    user.domination_configurations.find_by_dominating_id(@dominating.id).each do |conf|
      @dominations[conf.dominating.name] << conf.dominated.name
      @dominations[conf.dominating.name].uniq!
    end
    @dominated = @dominations[params[:dominating]]
    dc = DominationConfiguration.new(:dominating_id => params[:feature_class][:id])
    user.domination_configurations << dc
    redirect_to :action => :config_dominations    
  end

  
end