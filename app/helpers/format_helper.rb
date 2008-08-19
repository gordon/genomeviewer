module FormatHelper
  Format.list_colors.each do |c|
    define_method "#{c}_column" do |record|
      content_tag :div, '&nbsp;',
        :class => 'square',
        :style => "background-color: #{record.send(c)};"
    end
  end
end