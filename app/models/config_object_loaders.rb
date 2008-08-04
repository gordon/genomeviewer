#
# This module contains helper functions for the User model
# that allow to load the user configuration options in the 
# config object.
#
module ConfigObjectLoaders
  
  def load_user_specific_configurations
    load_colors
    load_styles
    load_drawing_formats
    load_dominations
    load_collapses
  end
  
  def load_colors
    color_configurations.each do |conf|
      color = GTServer.new_color_object
      color.red = conf.red.to_f
      color.green = conf.green.to_f
      color.blue = conf.blue.to_f
      @config_object.set_color(conf.element.name, color)
    end
  end

  def load_styles
    feature_style_configurations.each do |record|
      @config_object.set_cstr("feature_styles",
                             record.feature_class.name,
                             record.style.name)
    end
  end

  def load_drawing_formats
    return unless drawing_format_configuration
    dfc = drawing_format_configuration
    # set show_grid
    show_grid = dfc.show_grid ? "yes" : "no"
    @config_object.set_cstr("format",
                           "show_grid",
                           show_grid)
    # set all other format attributes
    dfc.pixel_attribute_names.each do |attr|
      @config_object.set_num("format",
                attr,
                dfc.send(attr).to_f)
    end
  end

  def load_dominations
    domination_configurations.each do |conf|
      unless conf.dominated_features.empty?
        dfs = conf.dominated_features.map(&:feature_class).map(&:name)
        @config_object.set_cstr_list("dominate",
                                    conf.dominator.name,
                                    dfs)
      else
        @config_object.set_cstr_list("dominate", conf.dominator.name, [])
      end
    end
  end

  def load_collapses
    return unless collapsing_configuration
    @config_object.set_cstr_list("collapse",
                                "to_parent",
                                collapsing_configuration.to_parent)
  end

end