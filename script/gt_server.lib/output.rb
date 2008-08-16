#
# output methods as image (png format) and image map on the png image
#
# these methods assume that the parameters are correct,
# that is they must be validated at higher level or can
# bring the gtserver to crash
module Output
  
  # returns the image for the sequence with the given seqid 
  # in a filename, in the given range, using the given config object
  # and the given width in pixel (the height depends on the number 
  # of tracks displayed) and with or without adding introns
  def image(filename, seqid, range, config_obj, width, add_introns, uncache = true)
    log "#{filename}: image map"
    fetch_img_or_map(:img, filename, seqid, range, config_obj, width, add_introns, uncache)
  end

  # returns the image map using the same set of parameters of the image method
  def image_map(filename, seqid, range, config_obj, width, add_introns, uncache = true)
    log "#{filename}: image map"
    fetch_img_or_map(:map, filename, seqid, range, config_obj, width, add_introns, uncache)
  end
  
  def image_cached?(filename, seqid, range, config_obj, width, add_introns)
    key = [filename, seqid, range, config_obj, width, add_introns].hash
    lock(:img) do 
      @cache[:img].has_key?(key)
    end
  end
  
  def image_map_cached?(filename, seqid, range, config_obj, width, add_introns)
    key = [filename, seqid, range, config_obj, width, add_introns].hash
    lock(:map) do 
      @cache[:map].has_key?(key)
    end
  end
  
  # returns the deleted objects or nil if nothing deleted
  def image_and_map_uncache(filename, seqid, range, config_obj, width, add_introns)
    key = [filename, seqid, range, config_obj, width, add_introns].hash
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
  
  def fetch_img_or_map(mode, filename, seqid, range, config_obj, width, add_introns, uncache)
    log "seqid: #{seqid} (#{range.first} - #{range.last})", 2
    log "width: #{width}px; add_introns #{add_introns ? 'on' : 'off'}", 2
    params = [filename, seqid, range, config_obj, width, add_introns]
    key = *params.hash
    obj = nil
    lock(mode) do
      obj = uncache ? @cache[mode].delete(key) : @cache[mode].fetch(key, nil) 
    end
    if obj
      return obj
    else
      render(*params)
      lock(mode) do
        obj = uncache ? @cache[mode].delete(key) : @cache[mode].fetch(key, nil) 
      end
      return obj
    end
  end
  
  def render(filename, seqid, range, config_obj, width, add_introns)
    key = [filename, seqid, range, config_obj, width, add_introns].hash
    mode = add_introns ? :on : :off
    log "rendering", 3
    fix = feature_index(filename, mode)
    gtrange = fix.get_range_for_seqid(seqid)
    gtrange.start = range.first
    gtrange.end   = range.last
    diagram = GT::Diagram.new(fix, seqid, gtrange, config_obj)
    info = GT::ImageInfo.new
    canvas = GT::Canvas.new(config_obj, width, info)
    diagram.render(canvas)
    lock(:map) do 
      @cache[:map][key] = info
    end
    lock(:img) do
      @cache[:img][key] = canvas.to_stream
    end
    log "done", 3
  end
  
end
