module FeatureTypesHelper
    
  def style_form_column(record, input_name)
    opts = options_for_select(["default"]+Style::DefinedStyles.values, record.style.to_s)
    select_tag input_name, opts
  end
  
  FeatureType.list_colors.each do |c|
    define_method "#{c}_column" do |record|
      content_tag :div, '&nbsp;',
        :class => 'square',
        :style => "background-color: #{record.send(c)};"
    end
  end
  
end
