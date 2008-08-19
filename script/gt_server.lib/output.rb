#
# output methods as image (png format) and image map on the png image
#
# these methods assume that the parameters are correct,
# that is they must be validated at higher level or can
# bring the gtserver to crash
module Output
  
  # returns the image for the sequence with the given seqid 
  # in a filename, in the given range, using a copy of the given 
  # config object and the given width in pixel (the height 
  # depends on the number of tracks displayed) and with or 
  # without adding introns
  #
  # the boolean parameter uncache can be set to false to avoid
  # deleting the cache after reading the image (this is usually 
  # not desired, as images with exactly the same parameters 
  # are unlikely and are usually cached by the browser)
  #
  # config_override is an array of arrays, defining options which 
  # are applied on the copy of the config object used for image 
  # rendering. Each subarray must be in the format:
  #
  #   [gt_ruby_type, section, attribute, value]. 
  #
  def image(filename, seqid, range, config_obj, width, add_introns, 
            uncache = true, config_override = {})
    log "#{filename}: image"
    fetch_img_or_map(:img, filename, seqid, range, config_obj, 
                     width, add_introns, uncache, config_override)
  end

  # returns the image map using the same set of parameters of the image method
  def image_map(filename, seqid, range, config_obj, width, add_introns, 
                uncache = true, config_override = {})
    log "#{filename}: image map"
    fetch_img_or_map(:map, filename, seqid, range, config_obj, 
                     width, add_introns, uncache, config_override)
  end
  
  def image_cached?(filename, seqid, range, config_obj, 
                    width, add_introns, config_override = {})
    key = [filename, seqid, range, config_obj, 
           width, add_introns, config_override].hash
    lock(:img) do 
      @cache[:img].has_key?(key)
    end
  end
  
  def image_map_cached?(filename, seqid, range, config_obj, 
                        width, add_introns, config_override = {})
    key = [filename, seqid, range, config_obj, 
          width, add_introns, config_override].hash
    lock(:map) do 
      @cache[:map].has_key?(key)
    end
  end
  
  # returns the deleted objects or nil if nothing deleted
  def image_and_map_uncache(filename, seqid, range, config_obj, width, add_introns)
    key = [filename, seqid, range, config_obj, 
           width, add_introns, config_override].hash
    d = []
    [:map, :img].each do |mode|
      lock(mode) do 
        d << @cache[mode].delete(key)
      end      
    end
    d.compact!
    unless d.empty? 
      log "#{filename}: img/map cache #{key} emptied"
      return d
    else
      log "#{filename}: no img/map cache #{key}"
      return nil
    end
  end
  
  private
  
  def fetch_img_or_map(mode, filename, seqid, range, config_obj, 
                       width, add_introns, uncache, config_override)
    log "seqid: #{seqid} (#{range.first} - #{range.last})", 2
    log "width: #{width}px; add_introns #{add_introns ? 'on' : 'off'}", 2
    params = [filename, seqid, range, config_obj, 
              width, add_introns, config_override]
    key = *params.hash
    obj = nil
    lock(mode) do
      obj = uncache ? @cache[mode].delete(key) : @cache[mode].fetch(key, nil) 
    end
    if obj
      log "cached", 3
      return obj
    else
      render(*params)
      lock(mode) do
        obj = uncache ? @cache[mode].delete(key) : @cache[mode].fetch(key, nil) 
      end
      return obj
    end
  end
  
  require 'benchmark'
  
  def render(filename, seqid, range, config_obj, width, 
             add_introns, config_override)
    log "rendering", 3
    time = Benchmark.measure do 
      key = [filename, seqid, range, config_obj, 
             width, add_introns, config_override].hash
      config_copy = config_obj #.clone
      # here the config override should be applied
      mode = add_introns ? :on : :off
      fix = feature_index(filename, mode)
      gtrange = fix.get_range_for_seqid(seqid)
      gtrange.start = range.first
      gtrange.end   = range.last
      diagram = GT::Diagram.new(fix, seqid, gtrange, config_copy)
      info = GT::ImageInfo.new
      canvas = GT::Canvas.new(config_copy, width, info)
      diagram.render(canvas)
      lock(:map) do 
        @cache[:map][key] = info
      end
      lock(:img) do
        @cache[:img][key] = canvas.to_stream
      end
    end
    log "done (%.4fs)" % time.real, 3
  end
  
end
