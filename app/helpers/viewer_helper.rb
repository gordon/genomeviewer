module ViewerHelper

  def seq_id_selector
    seqids = @sequence_regions.map(&:seq_id)
    opts = options_for_select(seqids, @sequence_region.seq_id)
    "Sequence: "+
    select_tag("seq_region", opts, :id => "seq_id_selector")
  end

  #
  # this allows to submit the form to an URL
  # that is still meaningful when used with
  # HTTP-GET method (i.e. saves some of the
  # information from the form in the URL)
  #
  # the remaining information, i.e. width and feature
  # types table, is still available in requests
  # sent by the form (using the HTTP-POST method)
  # but not e.g. saving the URL in the favourites
  #
  def settings_form_submit
    <<-end_js
      seq_id = $("seq_id_selector").value;
      sp = $("start_pos").value;
      ep = $("end_pos").value;
      url_prefix = form.action;
      url_suffix = seq_id + '/' + sp + '/' + ep;
      form.action = url_prefix + url_suffix;
      form.submit();
    end_js
  end

  def ft_cb_show_clicked(ftn)
    <<-end_js
      if ($("ft[#{ftn}][show]").checked)
      {
        ($("ft[#{ftn}][max_show_width]").disabled = false);
        ($("ft[#{ftn}][max_show_width]").value = '');
        ($("ft[#{ftn}][capt]").checked = true);
        ($("ft[#{ftn}][capt]").disabled = false);
        ($("ft[#{ftn}][max_capt_show_width]").disabled = false);
        ($("ft[#{ftn}][max_capt_show_width]").value = '');
      }
      else
      {
        ($("ft[#{ftn}][max_show_width]").disabled = true);
        ($("ft[#{ftn}][max_show_width]").value = '0');
        ($("ft[#{ftn}][capt]").checked = false);
        ($("ft[#{ftn}][capt]").disabled = true);
        ($("ft[#{ftn}][max_capt_show_width]").disabled = true);
        ($("ft[#{ftn}][max_capt_show_width]").value = '0');
      }
    end_js
  end

  def ft_cb_capt_clicked(ftn)
    <<-end_js
      if ($("ft[#{ftn}][capt]").checked)
      {
        ($("ft[#{ftn}][max_capt_show_width]").disabled = false);
        ($("ft[#{ftn}][max_capt_show_width]").value = '');
      }
      else
      {
        ($("ft[#{ftn}][max_capt_show_width]").disabled = true);
        ($("ft[#{ftn}][max_capt_show_width]").value = '0');
      }
    end_js
  end

  ### ajax ###

  def ajax_replacer
    remote_function(:with => "'movement='+$('image').style.left",
                    :url =>{:action => :ajax_movement,
                            :username => @annotation.user.username,
                            :annotation => @annotation.name,
                            :seq_region => @sequence_region.seq_id,
                            :start_pos => @start,
                            :end_pos => @end})
  end

  ### buttons ###

  def zoom_out_button
    if @start == @seq_begin and @end == @seq_end
      return zoom_out_icon_inactive
    else
      return link_to(zoom_out_icon,
                     :action => :index,
                     :username => @annotation.user.username,
                     :annotation => @annotation.name,
                     :seq_region => @sequence_region.seq_id,
                     :start_pos => (@start-@current_lenght/4).round,
                     :end_pos => (@end+@current_lenght/4).round)
    end
  end

  def back_button
    if @start == @seq_begin
      return back_icon_inactive
    else
      old_window = @end-@start+1
      new_start = @start - (old_window*@current_lenght/2).round
      new_start = @seq_begin if new_start < @seq_begin
      new_start = @end -1 if new_start >= @end

      new_end = new_start + old_window
      if new_end > @seq_end
        new_end = @seq_end
        new_start = new_end - old_window
      end
      return link_to(back_icon,
            :action => :index,
            :username => @annotation.user.username,
            :annotation => @annotation.name,
            :seq_region => @sequence_region.seq_id,
            :start_pos =>  new_start,
            :end_pos => new_end)
    end
  end

  def forward_button
    if @end == @seq_end
      return forward_icon_inactive
    else
      old_window = @end-@start+1
      new_start = @start + (old_window*@current_lenght/2).round
      new_start = @seq_begin if new_start < @seq_begin
      new_start = @end -1 if new_start >= @end

      new_end = new_start + old_window
      if new_end > @seq_end
        new_end = @seq_end
        new_start = new_end - old_window
      end
      return link_to(forward_icon,
            :action => :index,
            :username => @annotation.user.username,
            :annotation => @annotation.name,
            :seq_region => @sequence_region.seq_id,
            :start_pos =>  new_start,
            :end_pos => new_end)
    end
  end

  def zoom_in_button
    new_start = (@start+@current_lenght/4).round
    new_end = (@end-@current_lenght/4).round
    if new_end-new_start < 10
      return zoom_in_icon_inactive
    else
      return link_to(zoom_in_icon,
                     :action => :index,
                     :username => @annotation.user.username,
                     :annotation => @annotation.name,
                     :seq_region => @sequence_region.seq_id,
                     :start_pos => new_start,
                     :end_pos => new_end)
    end
  end

  def show_all_button
    if @start == @seq_begin and @end == @seq_end
      return show_all_icon_inactive
    else
      return link_to(show_all_icon,
                     :action => :index,
                     :username => @annotation.user.username,
                     :annotation => @annotation.name,
                     :seq_region => @sequence_region.seq_id,
                     :start_pos => @seq_begin,
                     :end_pos => @seq_end)
    end
  end

  ### icons ###

  def zoom_out_icon
    image_tag "icons/zoom_out.png",
              :size => "32x32",
              :title => "zoom out",
              :alt => "(-)"
  end

  def zoom_out_icon_inactive
    image_tag "icons/zoom_out_inactive.png",
              :size => "32x32",
              :title => "you already see the whole sequence",
              :alt => "[-]"
  end

  def back_icon
    image_tag "icons/back.png",
              :size => "32x32",
              :title => "go left",
              :alt => "<<"
  end

  def back_icon_inactive
    image_tag "icons/back_inactive.png",
              :size => "32x32",
              :title => "you are at the beginning",
              :alt => "|<<"
  end

  def forward_icon
    image_tag "icons/forward.png",
              :size => "32x32",
              :title => "go right",
              :alt => ">>"
  end

  def forward_icon_inactive
    image_tag "icons/forward_inactive.png",
              :size => "32x32",
              :title => "you are at the end",
              :alt => ">>|"
  end

  def zoom_in_icon
    image_tag "icons/zoom_in.png",
              :size => "32x32",
              :title => "Zoom in",
              :alt => "(+)"
  end

  def zoom_in_icon_inactive
    image_tag "icons/zoom_in_inactive.png",
              :size => "32x32",
              :title => "Zoom in",
              :alt => "(+)"
  end

  def show_all_icon
    image_tag "icons/show_all.png",
              :size => "32x32",
              :title => "view full sequence",
              :alt => "|<-->|"
  end

  def show_all_icon_inactive
    image_tag "icons/show_all_inactive.png",
              :size => "32x32",
              :title => "you already see the whole sequence",
              :alt => "[<-->]"
  end

  def map_tag(image_info)
    content_tag(:map, :name => "imap", :id => "imap") do
      content = ''
      image_info.each_hotspot do |x1, y1, x2, y2, feature|
        coords = [x1, y1, x2, y2].join(", ")
        content << hotspot_area_tag(coords, feature)
      end
      content
    end
  end

  def hotspot_area_tag(coords, feature)
    tag :area,
        # use boxover to create a js tooltip:
        :title => "header=[#{feature.get_attribute("ID")}] "+
                  "body=[#{tooltip_table(feature)}]"+
                  "cssheader=[tooltip_header]"+
                  "cssbody=[tooltip_body]",
        :shape => 'rect',
        :coords => coords,
        :href => 'javascript:void(0);',
        :ondblclick => "javascript:#{tooltip_zoomer(feature)};"
  end

  def tooltip_zoomer(feature)
    range = feature.get_range
    remote_function(:url =>{:action => :ajax_reloader,
                            :username => @annotation.user.username,
                            :annotation => @annotation.name,
                            :seq_region => @sequence_region.seq_id,
                            :start_pos => range.begin,
                            :end_pos => range.end})
  end

  def tooltip_table(feature)
    content_tag(:table) do
      content = ""
      info(feature).each do |k, v|
        tr = content_tag(:tr) do
          content_tag(:td, k)+
          content_tag(:td, v)
        end
        content << tr
      end
      content
    end
  end

  def info(feature)
    i = [] # no hash, so order remains constant
    i << ["Type", feature.get_type]
    range = feature.get_range
    i << ["Range", "#{range.begin} - #{range.end}"]
    score = feature.get_score
    (i << ["Score", score]) if score
    feature.each_attribute {|k,v| (i << [k, v])}
    return i
  end

end
