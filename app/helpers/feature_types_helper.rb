module FeatureTypesHelper
  
  def style_form_column(record, input_name)
    opts = options_for_select(["default"]+Style::DefinedStyles.values, record.style.to_s)
    select_tag input_name, opts
  end
  
end