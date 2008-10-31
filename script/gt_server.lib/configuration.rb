#
# DRb can't serialize GTRuby Objects like GT::Color and GT::Style
# therefore only references to them are used in Genomeviewer, while
# the object instances themselves are created on the server.
#
module Configuration

  #
  # gtruby config object associated to
  # the given key or a new one if none cached
  #
  def config(key)
    cnf = nil
    lock(:c) do
      cnf = @cache[:c].fetch(key, nil)
    end
    if cnf
      log "config #{key} (cached)"
    else
      lock(:c) do
        @cache[:c][key] = config_new
        cnf = @cache[:c][key]
      end
      log "config #{key} (new)"
    end
    return cnf
  end

  #
  # a config object with
  # the default configuration
  #
  def config_default
    lock(:c) do
      @cache[:c][:default] ||= config_new
    end
  end

  #
  # delete a config object from the cache
  # and return it (or nil if this did not exist)
  #
  def config_uncache(key)
    cnf = nil
    lock(:c) do
      cnf = @cache[:c].delete(key)
    end
    log cnf ?
      "config #{key} deleted" :
      "config #{key} not cached, not deleted"
    cnf
  end

  #
  # does the cache contain a config object for this key?
  #
  def config_cached?(key)
    lock(:c) do
      @cache[:c].has_key?(key)
    end
  end

  #
  # a new config object with settings from config/view.lua
  #
  def config_new
    cnf = GT::Style.new
    cnf.load_file File.expand_path("config/view.lua",
                                 "#{File.dirname(__FILE__)}/../..")
    log "new config, view.lua loaded", 2
    return cnf
  end

  #
  # a new color object
  #
  def color_new
    return GT::Color.malloc
  end

end
