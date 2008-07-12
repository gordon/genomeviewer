module ConfigModules::Colors

  ### actions with a template ###

  def config_colors
    user = User.find(session[:user])
    @colors = ColorConfiguration.defaults 
    # override defaults with user specific information
    user.color_configurations.each do |conf|
      @colors[conf.element.name] ||= {}
      [:red,:green,:blue].each do |color|
        @colors[conf.element.name][color] = conf.send(color).to_f
      end
    end
    @not_configured = []
    @colors.each_pair do |element_name, color|
      gray_feature = (color[:red] == 0.8 and 
                  color[:green] == 0.8 and 
                  color[:blue] == 0.8 and 
                  FeatureClass.find_by_name(element_name))
      if gray_feature
        @not_configured << FeatureClass.find_by_name(element_name)
        @colors.delete(element_name) if gray_feature
      end
    end
    @title = "Configuration"
    @subtitle = "Colors"
  end
  
  ### actions redirecting to other actions ###
  
  def add_color_config
    user = User.find(session[:user])
    element = FeatureClass.find(params[:feature_class][:id])
    new_color_conf = ColorConfiguration.new(:element => element,
                                                        :red => 0.0, 
                                                        :green => 0.0, 
                                                        :blue => 0.0)
      old_color_conf = 
        user.color_configurations.find_by_element_id_and_element_type(element.id, element.class.to_s)
      user.color_configurations.delete(old_color_conf) unless old_color_conf.nil?
      user.color_configurations << new_color_conf    
      flash[:notice] = "You can now configure #{element.name}.<br/>"+\
                          "It was added to the list with values 0.0, 0.0, 0.0 (black)."
    redirect_to :action => :config_colors
  end
  
  def do_config_colors
    user = User.find(session[:user])
    defaults = ColorConfiguration.defaults
    params[:colors].each_pair do |element_name, colors|
      element = FeatureClass.find_by_name(element_name) \
                    || GraphicalElement.find_by_name(element_name)
      new_color_conf = ColorConfiguration.new(:element => element,
                                                        :red => colors[:red], 
                                                        :green => colors[:green], 
                                                        :blue => colors[:blue])
      old_color_conf = 
        user.color_configurations.find_by_element_id_and_element_type(element.id, element.class.to_s)
      user.color_configurations.delete(old_color_conf) unless old_color_conf.nil?
      user.color_configurations << new_color_conf
    end
    redirect_to :action => :config_colors
  end
  
  def reset_color
    user = User.find(session[:user])
    element = FeatureClass.find_by_name(params[:element]) \
                    || GraphicalElement.find_by_name(params[:element])
    user_conf = 
      user.color_configurations.find_by_element_id_and_element_type(element.id, element.class.to_s)
    user.color_configurations.delete(user_conf) unless user_conf.nil?
    redirect_to :action => :config_colors
  end

end