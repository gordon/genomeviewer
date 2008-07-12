module ConfigModules::Collapse

  ### action with a template ###

  def config_collapse
    user = User.find(session[:user])
    @collapse = 
      if user.collapsing_configuration
        user.collapsing_configuration.to_parent 
      else 
        CollapsingConfiguration.default
      end
    @not_collapsing = 
      FeatureClass.find(:all).delete_if {|fc| @collapse.include? fc.name}
    @title = "Configuration"
    @subtitle = "Collapsing to parent"
  end
  
  ### actions redirecting to other actions ###
  
  def collapse_remove
    user = User.find(session[:user])
    unless user.collapsing_configuration
      user.collapsing_configuration = CollapsingConfiguration.new 
      user.collapsing_configuration.to_parent = CollapsingConfiguration.default
      user.collapsing_configuration.save
    end
    user.collapsing_configuration.to_parent.delete(params[:feature_class_name])     
    user.collapsing_configuration.save
    if user.collapsing_configuration.to_parent == CollapsingConfiguration.default
      user.collapsing_configuration = nil
    end
    redirect_to :action => :config_collapse
  end
  
  def collapse_add
    user = User.find(session[:user])
    unless user.collapsing_configuration
      user.collapsing_configuration = CollapsingConfiguration.new 
      user.collapsing_configuration.to_parent = CollapsingConfiguration.default
      user.collapsing_configuration.save
    end
    user.collapsing_configuration.to_parent << 
                   FeatureClass.find(params[:feature_class][:id]).name  
    user.collapsing_configuration.save
    if user.collapsing_configuration.to_parent == CollapsingConfiguration.default
      user.collapsing_configuration = nil
    end
    redirect_to :action => :config_collapse
  end
    
  def reset_collapse_list
    user = User.find(session[:user])
    user.collapsing_configuration = nil
    user.save
    redirect_to :action => :config_collapse
  end    

end