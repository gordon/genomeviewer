class ViewerController < ApplicationController
  
  before_filter :initialization, :except => "image"
  def initialization
    
    get_annotation
    check_permission
    get_seq_region
    get_width
    get_range
    get_ft_settings
    get_add_introns
    
  rescue => err
  
    flash[:errors] = err.to_s
    redirect_to(@current_user ? own_files_url : root_url)    
    
  end
  
  ### actions with a template ###
  
  #
  # The main page, with the sequence region selector
  #
  def index
    
    # visualization parameters
    @seq_ids_per_line = 10
    @title = @annotation.name
    get_values_for_orientation_bar
    generate_img_and_map
    
  end
  
  ### actions for ajax ###
  
  def ajax_movement
    
    # @start and @end are currently the old ones
    # their new values must be calculated using params[:movement]    
    movement = params[:movement].to_f / @width
    
    if (@start == @seq_begin and movement > 0) or 
       (@end == @seq_end and movement < 0)
      
      @out_of_range = true
      
    else
      
      old_window = @end-@start+1
      
      @start -= (old_window*movement).round     
      @start = @seq_begin if @start < @seq_begin
      @start = @end -1 if @start >= @end        
      
      @end = @start + old_window
      if @end > @seq_end 
        @end = @seq_end 
        @start = @end - old_window
      end
      
      get_values_for_orientation_bar
      generate_img_and_map

    end
    
  end
  
  def ajax_reloader
    get_values_for_orientation_bar
    generate_img_and_map
    render :action => "ajax_movement.js.rjs"
  end

  ### image ###
  
  def image
    uuid = params[:uuid]
    unless GTServer.img_exists?(uuid)
      # this happens if the GTServer goes down between the page request
      # and the image request; in this case reconstruct the request 
      # using the temporary UUID logs table
      args = UuidLog.find_by_uuid(uuid).args
      args.unshift(uuid)
      args[4] = Configuration.find(args[4]).gt
      GTServer.img_and_map_generate(*args)
    end
    send_data GTServer.img(uuid),
              :type => "image/png",
              :disposition => "inline",
              :filename => "#{uuid}.png"
  end
  
  private
  
  ### helper functions for the initialization filter ###

  def get_annotation
    raise "No annotation specified!" unless params[:annotation]
    @annotation = 
      Annotation.find(:first, 
                      :conditions => 
                        {:name => params[:annotation],
                         :user_id => User.find_by_username(params[:username])}, 
                      :include => :sequence_regions)
    raise "This annotation is not available anymore." unless @annotation
  end
  
  def check_permission
    @own = (@annotation.user == @current_user)
    raise "Private annotations can be visualized only by their owners." \
      unless @own or @annotation.public
  end
    
  def get_seq_region
    # check sequence region
    @sequence_regions = @annotation.sequence_regions
    @sequence_region = params[:seq_region] ? 
          @sequence_regions.find_by_seq_id(params[:seq_region]) :
          @sequence_regions.first # default fallback
    raise "Sequence region not available for this annotation." \
          unless @sequence_region
  end    
  
  def get_width(default_width = 900)
    if params[:width] 
      @width = params[:width].to_i
    elsif session[:width]
      @width = session[:width]
    else
      @width = @current_user ? 
        @current_user.configuration.width : 
        default_width
    end
    session[:width] = @width
  end
  
  def get_range
    # begin and end of the sequence region
    @seq_begin = @sequence_region.seq_begin
    @seq_end = @sequence_region.seq_end
    
    # begin of the current view
    if params.has_key?(:start_pos) and params[:start_pos].to_i >= @seq_begin 
      @start = params[:start_pos].to_i
      @start = @seq_end - 1 if @start > @seq_end
    else
      @start = @seq_begin
    end
    
    # end of the current view
    if params.has_key?(:end_pos) and params[:end_pos].to_i <= @seq_end
      @end = params[:end_pos].to_i
      @end = @seq_begin + 1 if @end < @seq_begin
    else
      @end = @seq_end
    end
  end
  
  def get_values_for_orientation_bar
    @total_lenght = (@seq_end - @seq_begin + 1).to_f
    @current_lenght = (@end - @start + 1).to_f
    @current_width = (@current_lenght / @total_lenght * 100).round
    @current_left_margin = ((@start - @seq_begin + 1) / @total_lenght * 100).round
  end
  
  def get_add_introns
    if params[:add_introns] 
      @add_introns = (params[:add_introns]=="1")
    elsif session[:add_introns] and session[:add_introns][@annotation.name]
      @add_introns = session[:add_introns][@annotation.name]
    else
      @add_introns = @annotation.add_introns
    end
    # save in the session
    session[:add_introns] ||= {}
    session[:add_introns][@annotation.name] = @add_introns
    # save in the db if logged in
    if @current_user
      @annotation.update_attributes(:add_introns => @add_introns)
    end
  end
  
  def get_ft_settings
    @annotation_ft_settings = @annotation.feature_type_in_annotations
    @ft_settings = {}
    
    if params[:commit] ### settings form ###
      params[:ft].each do |ft_name, setting|
        @ft_settings[ft_name] = {} 
        ft_id = FeatureType.find_by_name(ft_name).id
        unless setting[:show]
          @ft_settings[ft_name][:show] = 0
          @ft_settings[ft_name][:capt] = 0
        else
          # nil means infinite, show at any width
          show = (Integer(setting[:max_show_width]) rescue nil)
          @ft_settings[ft_name][:show] = show
          unless setting[:capt]
            @ft_settings[ft_name][:capt] = 0
          else
            # again: nil means infinite, show at any width
            capt = (Integer(setting[:max_capt_show_width]) rescue nil)
            @ft_settings[ft_name][:capt] = capt
          end
        end
        if @current_user
          # save settings in the DB
          ft_in_a = @annotation_ft_settings.find_by_feature_type_id(ft_id)
          ft_in_a.max_show_width      = @ft_settings[ft_name][:show]
          ft_in_a.max_capt_show_width = @ft_settings[ft_name][:capt]
          ft_in_a.save
        end
      end
    elsif session[:ft_settings] and  ### session hash ###
            session[:ft_settings].
              fetch(@annotation.name,{}).
                fetch(@sequence_region.seq_id, false)  
      @ft_settings = 
        session[:ft_settings][@annotation.name][@sequence_region.seq_id]
    else ### annotation default options ###
      @annotation_ft_settings.each do |setting|
        @ft_settings[setting.feature_type.name] = {}
        @ft_settings[setting.feature_type.name][:show] = 
                                                setting.max_show_width
        @ft_settings[setting.feature_type.name][:capt] = 
                                           setting.max_capt_show_width
      end
    end
    # save settings in the session hash
    session[:ft_settings] ||= {}
    session[:ft_settings][@annotation.name] ||= {}
    session[:ft_settings][@annotation.name][@sequence_region.seq_id] = 
                                                             @ft_settings
  end
    
  def generate_img_and_map
    @uuid = UUID.random_create.to_s
    config_obj = @current_user ? 
                   # logged in: use the user config object
                   @current_user.configuration.gt : 
                   # not logged in: use the config object of 
                   # the user to whom the annotation belongs
                   # (other possibility would be the default 
                   #  config object GTServer.config_default)
                   @annotation.user.configuration.gt
    config_override = []
    @ft_settings.each do |section, setting|
      config_override << ['num', section, 'max_show_width', setting[:show]]
      config_override << ['num', section, 'max_capt_show_width', setting[:capt]]
    end
    #
    # the request parameters are logged so that the request can 
    # be reconstructed in case the GTServer goes down between this 
    # code and the image request; see image() method
    #
    conf_id = 
    args = [@annotation.gff3_data_storage,
            @sequence_region.seq_id,
            (@start..@end),
            # as the config object is not serializable, use instead
            # for the uuid_log the corresponding configuration id
            @current_user ? 
                @current_user.configuration.id :
                @annotation.user.configuration.id,
            @width,
            @add_introns,
            config_override]
    UuidLog.create(:uuid => @uuid, :args => args)
    args.unshift(@uuid)
    args[4] = config_obj
    GTServer.img_and_map_generate(*args)
    @info = GTServer.map(@uuid)
  end
    
end
