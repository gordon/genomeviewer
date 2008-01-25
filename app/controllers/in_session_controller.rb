class InSessionController < ApplicationController

 prepend_before_filter :check_login

 def check_login
  unless session[:user]
   redirect_to :controller => :login, :action => :login
   session[:location]=params.clone
  end
  return true
 end

 def do_logout
  session[:user]=nil
  redirect_to :controller => :default, :action => :index
 end

 def do_upload
  @annotation = Annotation.new
  @annotation.name = params[:gff3_file].original_filename
  @annotation.user_id = session[:user]
  @annotation.description = params[:description] 
  @annotation.gff3_data = params[:gff3_file].read
  if @annotation.save
   flash[:notice] = "Successfully uploaded"
  else
   flash[:errors] = @annotation.errors.on_base
  end
  redirect_to :action => "upload"
 end

 def change_annotation_description
  annotation=Annotation.find(params[:annotation].to_i)
  # prevent others from mofifiing our data
  if annotation.user.id == session[:user]
   annotation.description=params[:description]
   annotation.save
  end
  redirect_to :action => "file_manager"
 end

 def file_delete
  annotation=Annotation.find(params[:annotation].to_i)
  # prevent others from mofifiing our data
  if annotation.user.id == session[:user]
   annotation.destroy
  end
  redirect_to :action => "file_manager"
 end

 def file_accessibility
  annotation=Annotation.find(params[:annotation].to_i)
  if params[:public] then public=true else public=false end
  # prevent others from mofifiing our data
  if annotation.user.id == session[:user]
   annotation.public=public
   annotation.save
  end
  redirect_to :action => "file_manager"
 end

  def config_formats
    user = User.find(session[:user])
    @formats = user.drawing_format_configuration || DrawingFormatConfiguration.new
  end
  
  def do_config_formats
    params[:format]["show_grid"] ||= false 
    user = User.find(session[:user])
    dfc = DrawingFormatConfiguration.new(params[:format])
    user.drawing_format_configuration = dfc
    user.save
    redirect_to :action => :config_formats
  end
  
  def do_reset_formats
    user = User.find(session[:user])
    user.drawing_format_configuration = nil
    user.save
    redirect_to :action => :config_formats
  end
  
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
  
  def config_styles
    user = User.find(session[:user])
    @styles = FeatureStyleConfiguration.defaults 
    # override defaults with user specific information
    user.feature_style_configurations.each do |conf|
      @styles[conf.feature_class.name] = conf.style.name
    end
  end
  
  def do_config_styles
    user = User.find(session[:user])
    p params[:styles]
    params[:styles].each_pair do |element_name, style_id|
      element = FeatureClass.find_by_name(element_name) 
      old_conf = user.feature_style_configurations.find_by_feature_class_id(element.id)
      user.feature_style_configurations.delete(old_conf) if old_conf
      new_conf = FeatureStyleConfiguration.new(:feature_class => element, :style_id => style_id)
      user.feature_style_configurations << new_conf
    end
    redirect_to :action => :config_styles
  end
  
  def reset_style
    user = User.find(session[:user])
    element = FeatureClass.find_by_name(params[:element])
    user_conf = user.feature_style_configurations.find_by_feature_class_id(element.id)
    user.feature_style_configurations.delete(user_conf) if user_conf
    redirect_to :action => :config_styles
  end

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
    
  def config_collapse
    user = User.find(session[:user])
    @collapse = 
      if user.collapsing_configuration
        user.collapsing_configuration.to_parent 
      else 
        CollapsingConfiguration.default
      end
  end

 private

 def initialize
  @stylesheets = "in_session"
 end

end