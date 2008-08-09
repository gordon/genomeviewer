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
    def set_section(section_name = nil, &block)
      define_method :section, block ? block : lambda {section_name}
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
    # * for each attribute defines a setter method #<attr>=(value) 
    #   that changes the value in the DB as well as the value 
    #   in the config object
    # * defines also a default getter method #default_<attr> 
    #   that returns the value from the default config object
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
        # (re-)define the attribute set method
        define_method "#{attr}=", send("#{config_type}_setter", attr)
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
         
    ### set method prototypes ###
     
    def floats_setter(attr)
      lambda do |value|
        value = Float(value)
        configuration.gt.set_num(section, attr.to_s, value) if configuration
        self[attr]=value
      end    
    end
    
    def integers_setter(attr)
      lambda do |value|
        value = Integer(value)
        configuration.gt.set_num(section, attr.to_s, value) if configuration
        self[attr]=value
      end    
    end
    
    def bools_setter(attr)
      lambda do |value|
        value = value ? true : false
        configuration.gt.set_bool(section, attr.to_s, value) if configuration
        self[attr]=value
      end
    end
    
    def colors_setter(attr)
      lambda do |value|
        raise ArgumentError, "color expected" unless value.kind_of?(Color)
        configuration.gt.set_color(section, attr.to_s, value.to_gt) if configuration
        # call the original method, defined by composed_of
        send("__#{attr}=", value)
      end
    end
    
    def style_setter(attr)
      lambda do |value|
        configuration.gt.set_cstr(section, attr.to_s, value.to_s) if configuration
        # call the original method, defined by composed_of
        send("__#{attr}=", value)
      end
    end
    
    ### default get method prototypes ###
    
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
