#
# output methods as image (png format) and image map on the png image
#
# these methods assume that the parameters are correct,
# that is they must be validated at higher level or can
# bring the gtserver to crash
module Output

  require "benchmark"

  #
  # this saves the resulting image and map under an unique
  # identifier which can be used subsequently to fetch them
  #
  # parameters:
  # - uuid:            string; an unique identifier,
  #                    e.g. generated by UUID.random_create.to_s
  # - filename:        string
  # - seq_id:          string
  # - range:           a ruby Range object
  # - config_obj:      a GT::Style object
  # - width:           integer (width in pixel)
  # - add_introns:     boolean (activate add introns mode?)
  # - config_override: an array of options that will override
  #                    the options in the config object
  #
  # each option in config_override is an array:
  #
  #     [gt_ruby_type, section, attribute, value]
  #
  # if value.nil? the attribute will be unset, otherwise set to
  # the given value
  #
  # returns true if the image and map could be successfully generated,
  # false if any exception was raised during the generation
  #
  def img_and_map_generate(uuid,
                           filename,
                           seqid,
                           range,
                           config_obj,
                           width,
                           add_introns,
                           config_override = [])

    log "generating img/map #{uuid}"
    log filename, 2
    log "#{seqid}, #{range.inspect}", 2
    time = Benchmark.measure do
      config_copy = config_obj.clone
      config_override.each do |option|
        gt_ruby_type, section,
        attribute, value = option
        if value.nil?
          config_copy.unset(section, attribute)
        else
          config_copy.send("set_#{gt_ruby_type}", section, attribute, value)
        end
      end
      mode = add_introns ? :on : :off
      fix = feature_index(filename, mode)
      gtrange = fix.get_range_for_seqid(seqid)
      gtrange.start = range.first
      gtrange.end   = range.last
      diagram = GT::Diagram.new(fix, seqid, gtrange, config_copy)
      info = GT::ImageInfo.new
      canvas = GT::CanvasCairoFile.new(config_copy, width, info)
      diagram.sketch(canvas)
      lock(:map) do
        @cache[:map][uuid] = info
      end
      lock(:img) do
        @cache[:img][uuid] = canvas.to_stream
      end
    end
    log "done (%.4fs)" % time.real, 3
    return true
  rescue => err
    log "ERROR: #{err}", 3
    return false
  end

  def img_and_map_destroy(uuid)
    d = []
    [:map, :img].each do |mode|
      lock(mode) do
        d << @cache[mode].delete(uuid)
      end
    end
    d.compact!
    unless d.empty?
      log "#{uuid}: img/map deleted"
      return d
    else
      log "#{uuid}: no img/map found"
      return nil
    end
  end

  #
  # returns the image saved under the specified uuid or nil
  #
  def img(uuid, delete = true)
    log("image #{uuid}")
    lock(:img) do
      delete ? @cache[:img].delete(uuid) : @cache[:img].fetch(uuid, nil)
    end
  end

  #
  # returns the image map saved under the specified uuid or nil
  #
  def map(uuid, delete = true)
    log("image map #{uuid}")
    lock(:map) do
      delete ? @cache[:map].delete(uuid) : @cache[:map].fetch(uuid, nil)
    end
  end

  def img_exists?(uuid)
    lock(:img) do
      @cache[:img].has_key?(uuid)
    end
  end

  def map_exists?(uuid)
    lock(:map) do
      @cache[:map].has_key?(uuid)
    end
  end

end
