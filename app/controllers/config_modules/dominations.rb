module ConfigModules::Dominations

  ### actions with a template ###

  def manage_dominated_list
    user = User.find(session[:user])
    @dominator = FeatureClass.global.find_by_name(params[:dominator])
    @dominator ||= FeatureClass.find_by_name_and_user_id(params[:dominator], user.id)
    dc = DominationConfiguration.find_by_user_id_and_dominator_id(session[:user], @dominator.id)
    if dc
      # an user specific list exists
      @dominated = dc.dominated_features.map(&:feature_class).map(&:name)
    else
      # return a default list or an empty list if no default exists
      @dominated = DominationConfiguration.defaults_for(user).fetch(params[:dominator], [])
    end
    @not_dominated = user.feature_classes.delete_if {|fc| @dominated.include?(fc.name) or fc == @dominator}
    @title = "Configuration"
    @subtitle = "Domination List of #{@dominator.name}"
  end

  def config_dominations
    user = User.find(session[:user])
    @dominations = DominationConfiguration.defaults_for(user)
    user.domination_configurations.each do |conf|
      @dominations[conf.dominator.name] = conf.dominated_features.map(&:feature_class).map(&:name)
    end    
    @not_dominating = 
      user.feature_classes.delete_if do |fc| 
       @dominations.keys.include? fc.name
      end
    @title = "Configuration"
    @subtitle = "Dominations"
  end 
        
  ### actions redirecting to other actions ###

  def reset_dominations
    user = User.find(session[:user])
    user.domination_configurations.destroy_all
    user.flush_config_cache
    redirect_to :action => :config_dominations
  end    
  
  def add_dominated_list
    user = User.find(session[:user])
    user.domination_configurations << 
      DominationConfiguration.new(:dominator_id => params[:feature_class][:id])
    user.flush_config_cache
    redirect_to :action => :manage_dominated_list, 
                   :dominator => FeatureClass.find(params[:feature_class][:id]).name
  end
  
  def delete_dominated_list
    user = User.find(session[:user])
    dominator = FeatureClass.global.find_by_name(params[:dominator])
    dominator ||= FeatureClass.find_by_name_and_user_id(params[:dominator], user.id)
    dc = DominationConfiguration.find_by_user_id_and_dominator_id(session[:user], dominator.id)
    if dc 
      # it was an user list, delete it 
      dc.destroy
    else 
      # it was a default list, create an empty list
      user.domination_configurations << DominationConfiguration.new(:dominator => dominator)
    end
    user.flush_config_cache
    redirect_to :action => :config_dominations
  end
  
  def reset_dominated_list
    user = User.find(session[:user])
    dominator = FeatureClass.global.find_by_name(params[:dominator])
    dominator ||= FeatureClass.find_by_name_and_user_id(params[:dominator], user.id)
    dc = DominationConfiguration.find_by_user_id_and_dominator_id(session[:user], dominator.id)
    dc.destroy if dc
    user.flush_config_cache
    redirect_to :action => :config_dominations
  end

  def dominated_remove
    user = User.find(session[:user])
    dominator = FeatureClass.find_by_name(params[:dominator])
    dc = DominationConfiguration.find_by_user_id_and_dominator_id(session[:user], dominator.id)
    unless dc # the user had no list 
      dc = DominationConfiguration.new(:dominator => dominator)    
      dc.dominated_features << DominationConfiguration.defaults_for(user)[dominator.name].map do |dominated_fcn|
          DominatedFeature.new(:feature_class => FeatureClass.find_by_name(dominated_fcn))
        end
      user.domination_configurations << dc
    end
    record_to_delete = dc.dominated_features.find(:first, 
                              :conditions => {:feature_class_id => FeatureClass.find_by_name(params[:feature_class_name]).id})
    dc.dominated_features.delete(record_to_delete)
    user.flush_config_cache
    redirect_to :action => :manage_dominated_list, :dominator => params[:dominator]
  end
  
  def dominated_add
    user = User.find(session[:user])
    dominator = FeatureClass.find_by_name(params[:dominator])
    dc = DominationConfiguration.find_by_user_id_and_dominator_id(session[:user], dominator.id)
    unless dc # the user had no list 
      dc = DominationConfiguration.new(:dominator => dominator)    
      dc.dominated_features << DominationConfiguration.defaults_for(user)[dominator.name].map do |dominated_fcn|
          DominatedFeature.new(:feature_class => FeatureClass.find_by_name(dominated_fcn))
        end
      user.domination_configurations << dc
    end
    dc.dominated_features << DominatedFeature.new(:feature_class => FeatureClass.find(params[:feature_class][:id]))
    user.flush_config_cache
    redirect_to :action => :manage_dominated_list, :dominator => params[:dominator]
  end

end