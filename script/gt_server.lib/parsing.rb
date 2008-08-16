module Parsing

  #
  # validates a file, returning nil if no errors were found,
  # an error message otherwise
  #
  def gff3_errors(filename)
    begin
      parse(filename, false)
      log "#{filename}: valid"
      return nil
    rescue => err
      log "#{filename}: invalid"
      return err.to_s
    end
  end
  
  #
  # returns the (eventually cached) feature types list for a filename
  #
  def gff3_feature_types(filename)
    ft = nil
    lock(:ft) do
      ft = @cache[:ft].fetch(filename, nil)
    end
    if ft
      log "#{filename}: cached feature types list"
      return ft
    else
      parse(filename)
      log "#{filename}: newly created feature types list"
      lock(:ft) do 
        return @cache[:ft][filename]
      end
    end
  end

  #
  # list of seqids of a gff3 file
  #
  def gff3_seqids(filename)
    log "#{filename}: sequence IDs list"
    feature_index(filename).get_seqids
  end
  
  #
  # returns the range of a sequence in a file, given the seqid
  #
  def gff3_range(filename, seqid)
    log "#{filename}: range of #{seqid}"
    r = feature_index(filename).get_range_for_seqid(seqid)
    (r.start..r.end)
  end

  #
  # deletes all cache entries for a filename
  # 
  def gff3_uncache(filename)
    d = []
    [:on, :off].each do |mode|
      lock(mode) do 
        d << @cache[mode].delete(filename)
      end
    end    
    lock(:ft) do 
      d << @cache[:ft].delete(filename)
    end
    d.compact!
    unless d.empty?
      log "#{filename}: cache deleted" 
      return d
    else 
      log "#{filename}: was not cached"
      return nil
    end
  end
  
  #
  # returns the (eventually cached) feature index for a filename
  #
  # the second parameter is one of the following: 
  #
  #  :on   => f. index with add_introns
  #  :off  => f. index without add_introns 
  #  nil   => any cached f.index or new without add_introns
  # 
  def feature_index(filename, mode = nil)
    raise "Mode unknown" unless [:on, :off, nil].include?(mode)
    fix = look_for_fix(mode, filename)
    if fix
      modestring = mode ? "(add introns #{mode})" : "(indifferent)"
      log "#{filename}: cached feature index #{modestring}"
      return fix
    else
      mode = :off if mode.nil?
      parse(filename, mode == :on)
      return look_for_fix(mode, filename)
      log "#{filename}: newly created feature index (add_introns #{mode})"        
    end
  end
    
  def look_for_fix(mode, filename)
    if mode
      lock(mode) do 
        return @cache[mode].fetch(filename, nil)
      end
    else
      off = look_for_fix(:off, filename)
      return off ? off : look_for_fix(:on, filename)
    end
  end
  private :look_for_fix
  
  # is there a feature index cache for this filename? 
  def feature_index_cached?(filename, mode = nil)
    if mode
      lock(mode) do 
        return @cache[mode].has_key?(filename)
      end
    else
      return [:on, :off].any?{|x| feature_index_cached?(filename, x)}
    end
  end

  # is there a feature types cache for this filename? 
  def feature_types_cached?(filename)
    lock(:ft) do 
      return @cache[:ft].has_key?(filename)
    end
  end

  def parse(filename, add_introns = false)
    
    log "#{filename}: parsing started"
    gff3_in_stream = GT::GFF3InStream.new(filename)

    if add_introns
      log "#{filename}: add introns on"
      in_stream = GT::AddIntronsStream.new(gff3_in_stream)
    else
      log "#{filename}: add introns off"
      in_stream = gff3_in_stream
    end

    feature_index = GT::FeatureIndex.new
    
    # populate feature stream:
    feature_stream = GT::FeatureStream.new(in_stream, feature_index)
    loop {break unless feature_stream.next_tree}    

    # cache feature index
    mode = add_introns ? :on : :off
    lock(mode) do 
      @cache[mode][filename] = feature_index
    end
    
    # cache used types
    lock(:ft) do 
      @cache[:ft][filename] = gff3_in_stream.get_used_types
    end
    
    log "#{filename}: parsing finished"
    
  end
  private :parse

end