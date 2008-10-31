#
# defines a DSL to use in classes which configure a "section" of the
# GT::Style object returned by the #configuration.gt method chain
#
module GTRubyConfigurator

  #
  # #configuration_attributes returns the attributes in the order
  # specified by this array (within each list in alphabetic order)
  #
  ConfigTypes = [:styles, :colors, :decimals, :integers, :bools]

  GTRubyType =
  {
    :decimals => :num,
    :integers => :num,
    :colors   => :color,
    :bools    => :bool,
    :styles   => :cstr
  }

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
      ConfigTypes.map{|t| @list[t].sort_by(&:to_s)}.flatten
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
    # the following instance methods are defined:
    #
    # * #section : name of the corresponding configuration section
    #
    # * #default : hash with all values of the configuration
    #              attributes for this section from config/value.lua
    #
    # * #local : hash with all values of the configuration
    #            attributes for this section from the current instance
    #
    # * #remote : hash with all values of the configuration
    #             attributes for this section from the gt config object
    #
    # * #sync? : is local == remote for all configuration attributes?
    #
    # * #not_sync : an array of arrays in the form:
    #              [attribute, local value, remote value]
    #              for each not synchronized attribute
    #
    # * #upload : set all configuration attributes for this section
    #             in the gt config to the current instance values
    #
    # * #upload_except(*attrs) : uploads all attributes except attrs
    #
    # * #download : set the current instance configuration attributes
    #               to the values from the corresponding gt config
    #
    # * #download_except(*attrs) : download all attributes except attrs
    #
    def set_section(section_name = nil, &block)
      define_method :section, block ? block : lambda {section_name}
      define_method :default, values_fetcher("default_")
      define_method :local,   values_fetcher("")
      define_method :remote,  values_fetcher("remote_")
      define_method :upload do
        upload_except # no exceptions
      end
      define_method :upload_except do |*not_to_upload|
        attrs = self.class.configuration_attributes - not_to_upload
        attrs.each {|attr| send("upload_#{attr}")}
      end
      define_method :download do
        download_except # no exceptions
      end
      define_method :download_except do |*not_to_upload|
        attrs = self.class.configuration_attributes - not_to_upload
        attrs.each {|attr| send("download_#{attr}")}
      end
      define_method :sync? do
        self.class.configuration_attributes.all? {|a| send("#{a}_sync?")}
      end
      define_method :not_sync do
        self.class.configuration_attributes.map do |attr|
          send("#{attr}_sync?") ? nil :
            [attr, send(attr), send("remote_#{attr}")]
        end.compact
      end
    end

    def values_fetcher(prefix)
      lambda do
        hsh = {}
        self.class.configuration_attributes.each do |attr|
          hsh[attr] = send("#{prefix}#{attr}")
        end
        hsh
      end
    end
    private :values_fetcher

    #
    # returns an instance with values from config/default.style
    #
    def default_new(attrs = {})
      base_instance = new(attrs)
      if [:default, :section].any?{|x|!base_instance.respond_to?(x)}
        raise "no place to get the default from; no set_section?"
      end
      return new(base_instance.default.merge(attrs))
    end

    #
    # usage examples:
    #
    #  set_floats :margins, :width, ...
    #  set_bools  :show_grid, ...
    #  set_colors :fill, ...
    #
    # effect:
    #
    # * populates the lists of attributes returned by .list_<config_type>
    #   and .configuration_attributes
    #
    # * the following instance methods are available for each attribute:
    #
    #     #<attr>            : works as usual (set instance value)
    #     #<attr>=           : works as usual (get instance value)
    #     #remote_<attr>     : get gt config value
    #     #remote_<attr>=(v) : set gt config value
    #     #sync_<attr>=(v)   : set both local and remote
    #     #default_<attr>    : get value from config/default.style
    #     #<attr>_sync?      : local == remote?
    #     #upload_<attr>     : instance => gt config
    #     #download_<attr>   : gt config => instance
    #
    ConfigTypes.each do |config_type|
      define_method "set_#{config_type}" do |*syms|
        define_macro(config_type, *syms)
      end
    end

    private

    def define_macro(config_type, *syms)
      # add symbols to lists
      class_eval {@list[config_type] += syms}
      syms.each do |attr|
        # map aggregations to attributes
        mapper = "#{config_type}_mapper"
        send(mapper, attr) if respond_to?(mapper, true)
        # define the instance methods
        define_method "remote_#{attr}", remote_getter(attr, config_type)
        define_method "remote_#{attr}=", remote_setter(attr, config_type)
        define_method "sync_#{attr}=", sync_setter(attr)
        define_method "#{attr}_sync?", sync_tester(attr)
        define_method "upload_#{attr}", uploader(attr)
        define_method "download_#{attr}", downloader(attr)
        define_method "default_#{attr}", default_reader(attr, config_type)
      end
    end

    ### aggregation callbacks ###

    def colors_mapper(sym)
      composed_of sym,
                  :class_name => "Color",
                  :mapping => [ ["#{sym}_red", "red"],
                                ["#{sym}_green", "green"],
                                ["#{sym}_blue", "blue"] ] do |v|
                                  case v
                                  when nil : Color.undefined
                                  when String : v.to_color
                                  else v
                                  end
                                end
    end

    def styles_mapper(sym)
      composed_of sym,
                  :class_name => "Style",
                  :mapping => [ ["#{sym}_key", "key"] ] do |v|
                                case v
                                when nil : "undefined".to_style
                                when String : v.to_style
                                else v
                                end
                              end
    end

    ### get and set methods ###

    def sync_setter(attr)
      lambda do |value|
        send("remote_#{attr}=", value)
        send("#{attr}=", value)
      end
    end

    def remote_getter(attr, config_type, from = nil)
      cast =
        case config_type
          when :colors : lambda {|v| v.nil? ? Color.undefined : Color(v)}
          when :styles : lambda {|v| v.nil? ? Style.undefined : v.to_style}
          when :integers : lambda {|v| v.nil? ? nil : v.to_i}
          when :decimals : lambda {|v| v.nil? ? nil : BigDecimal(v.to_s)}
          else             lambda {|v| v}
        end
      return lambda do
        raise "no place to get from" unless configuration
        gtr_type = GTRubyType[config_type]
        config_obj = from || configuration.gt(section, attr)
        raw = config_obj.send("get_#{gtr_type}", section, attr.to_s)
        value = cast.bind(self).call(raw)
      end
    end

    def remote_setter(attr, config_type, to = nil)
      cast =
        case config_type
          when :colors : lambda {|v| (v.nil? or v.undefined?) ? nil : v.to_gt}
          when :styles : lambda {|v| (v.nil? or v.undefined?) ? nil : v.to_s}
          when :decimals : lambda {|v| v.nil? ? nil : v.to_f}
          when :integers : lambda {|v| v.nil? ? nil : v.to_f}
          else             lambda {|v| v}
        end
      return lambda do |value|
        raise "no place to set into" unless configuration
        config_obj = to || configuration.gt(section, attr)
        casted = cast.bind(self).call(value)
        if casted.nil?
          config_obj.send("unset", section, attr.to_s)
        else
          gtr_type = GTRubyType[config_type]
          config_obj.send("set_#{gtr_type}", section, attr.to_s, casted)
        end
        return casted
      end
    end

    def sync_tester(attr)
      lambda do
        send(attr) == send("remote_#{attr}")
      end
    end

    ### default reader ###

    def default_reader(attr, config_type)
      remote_getter(attr, config_type, Configuration.default)
    end

    ### synchronization methods ###

    def uploader(attr)
      lambda do
        send("remote_#{attr}=", send(attr))
      end
    end

    def downloader(attr)
      lambda do
        send("#{attr}=", send("remote_#{attr}"))
      end
    end

  end

end
