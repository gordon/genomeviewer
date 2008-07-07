module ConfigModules::Styles

  def config_styles
    user = User.find(session[:user])
    @styles = FeatureStyleConfiguration.defaults 
    # override defaults with user specific information
    user.feature_style_configurations.each do |conf|
      @styles[conf.feature_class.name] = conf.style.name
    end
    @not_configured = []
    (FeatureClass.find(:all).map(&:name) - @styles.keys).each do |fc|
      @not_configured << FeatureClass.find_by_name(fc)
    end
  end
  
  def do_config_styles
    user = User.find(session[:user])
    params[:styles].each_pair do |element_name, style_id|
      element = FeatureClass.find_by_name(element_name) 
      old_conf = user.feature_style_configurations.find_by_feature_class_id(element.id)
      user.feature_style_configurations.delete(old_conf) if old_conf
      new_conf = FeatureStyleConfiguration.new(:feature_class => element, :style_id => style_id)
      user.feature_style_configurations << new_conf
    end
    redirect_to :action => :config_styles
  end
  
  def add_style_config
    user = User.find(session[:user])
    element = FeatureClass.find(params[:feature_class][:id])
    user.feature_style_configurations << 
                FeatureStyleConfiguration.new(:feature_class => element, 
                                                          :style => Style.find_by_name("box"))
    flash[:notice] = "You can now configure the style of #{element.name}.<br/>"+\
                          "It was added to the list with a default value 'box'."
    redirect_to :action => :config_styles
  end
  
  def reset_style
    user = User.find(session[:user])
    element = FeatureClass.find_by_name(params[:element])
    user_conf = user.feature_style_configurations.find_by_feature_class_id(element.id)
    user.feature_style_configurations.delete(user_conf) if user_conf
    redirect_to :action => :config_styles
  end

end