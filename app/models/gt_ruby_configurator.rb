#
# creates a DSL to use in classes which configures a "section"
# of the object returned by #configuration, i.e. its equivalent in 
# the GT::Configs object returned by the #configuration.gt method chain
#
module GTRubyConfigurator

  ConfigTypes = [:colors, :floats, :integers, :bools, :style]
    
  def self.included(klass)
    
    klass.class_eval do 
      # initialize lists of configuration attributes
      @list = {}
      ConfigTypes.each {|t| @list[t] = [] }
    end

    klass.extend(Lists)
    
    klass.extend(Macros)
    
  end  

  module Lists
    
    # define class methods to read lists of attributes
    ConfigTypes.each {|t| define_method "list_#{t}", lambda{@list[t]} }
    
    def configuration_attributes
      @list.values.flatten
    end
    
  end
  
  module Macros
  
    #
    # usage: (similar to set_primary_key)
    #
    # # a constant section name 
    # set_section "format" 
    #
    # # a block that will be passed to instances to calculate the section name
    # set_section do 
    #   self.name
    # end
    #
    # effect: 
    # 
    # * a #section instance method is defined, returning the name of the 
    #   configuration section that belongs to the instances of this class
    #
    # * a #upload instance method is defined which sets all attributes in 
    #   the gt config object 
    #
    # * an #upload_except(*attributes) is also defined, which excludes one 
    #   or more attributes to avoid circular references by uploading
    #
    def set_section(section_name = nil, &block)
      define_method :section, block ? block : lambda {section_name}
      define_method :upload do
        upload_except # no exceptions
      end
      define_method :upload_except do |*not_to_upload|
        attrs = self.class.configuration_attributes - not_to_upload
        attrs.each {|attr| send("upload_#{attr}")}
      end
    end
    
    #
    # usage: 
    #
    #  set_floats :margins, :width, ...
    #  set_bools :show_grid, ...
    #  set_colors :fill, ...
    #
    # effect: 
    #
    # * for each attribute defines an #upload_<attr> method that
    #   sets the value in the gt config object to the current 
    #   value of the attribute
    #
    # * for each attribute defines a setter method #<attr>=(value) 
    #   that changes the value in the DB and calls the #gt_set_<attr>
    #
    # * defines also a default getter method #default_<attr> 
    #   that returns the value from the default config object
    #
    # * populates the lists of attributes returned by .list_<config_type>
    #   and .configuration_attributes
    
    ConfigTypes.each do |config_type|
      define_method "set_#{config_type}" do |*syms|
        define_macro(config_type, *syms)
      end
    end
        
    private
        
    # defines setter and default getter methods for the 
    # given attributes of config_type
    def define_macro(config_type, *syms)
      # add symbols to lists
      class_eval {@list[config_type] += syms}
      syms.each do |attr|
        # map aggregations to attributes
        mapper = "#{config_type}_mapper"
        if respond_to?(mapper, true)
          send(mapper, attr)          
          # keep a reference to the original set method
          alias_method :"__#{attr}=", :"#{attr}=" 
        end
        # define the upload method
        define_method "upload_#{attr}", send("#{config_type}_upload", attr)
        # (re-)define the attribute set method
        define_method "#{attr}=", send("instance_set", attr)    
        # define the method to get the attribute default
        define_method "default_#{attr}", send("#{config_type}_default", attr)
      end    
    end
    
    ### aggregation callbacks ###
    
    def colors_mapper(sym)
        composed_of sym, 
                    :class_name => "Color",
                    :mapping => [ ["#{sym}_red", "red"],
                                  ["#{sym}_green", "green"],
                                  ["#{sym}_blue", "blue"] ]
    end
    
    def style_mapper(sym)
        composed_of sym, 
                    :class_name => "Style",
                    :mapping => [ ["#{sym}_key", "key"] ]
    end
    
    ### upload method prototypes ###
    
    def gt_config_set(set_method, attr, value_getter = lambda {send(attr)})
      lambda do 
        return false unless configuration
        args = set_method, section, attr.to_s, value_getter.bind(self).call
        configuration.gt(section, attr).send(*args)
        return true
      end
    end
    
    def floats_upload(attr)
      gt_config_set(:set_num, attr, lambda {Float(send(attr))})
    end
    
    def integers_upload(attr)
      gt_config_set(:set_num, attr, lambda {Integer(send(attr))})
    end
    
    def bools_upload(attr)
      gt_config_set(:set_bool, attr)
    end
    
    def colors_upload(attr)
      gt_config_set(:set_color, attr, lambda {send(attr).to_gt})
    end
    
    def style_upload(attr)
      gt_config_set(:set_cstr, attr)
    end
    
    ### set method prototype ###
    
    #
    # set the attribute to value 
    #
    # returns true if the setting of the gt config 
    # was successful, otherwise false
    #
    def instance_set(attr)
      lambda do |value|
        if respond_to?("__#{attr}=")
          send("__#{attr}=", value)
        else
          self[attr] = value
        end
        send("upload_#{attr}")
      end
    end
        
    ### default-get method prototypes ###
    
    def colors_default(attr)
      lambda do
        Color(Configuration.default.get_color(section, attr.to_s))
      end
    end
    
    def floats_default(attr)
      lambda do
        Configuration.default.get_num(section, attr.to_s)
      end
    end

    def integers_default(attr)
      lambda do
        Configuration.default.get_num(section, attr.to_s).to_i
      end
    end

    def bools_default(attr)
      lambda do
        Configuration.default.get_bool(section, attr.to_s)
      end
    end

    def style_default(attr)
      lambda do
        Configuration.default.get_cstr(section, attr.to_s).to_style
      end
    end
  
  end
      
end
