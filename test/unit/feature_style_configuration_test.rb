require File.dirname(__FILE__) + '/../test_helper'

class FeatureStyleConfigurationTest < ActiveSupport::TestCase

  fixtures :users, :feature_classes, :styles
  
  def test_load_feature_styles
    giorgio = users("giorgio")
    assert_not_equal giorgio.config.get_cstr("feature_styles","gene"),
                     "dashes"
    f = FeatureStyleConfiguration.new
    f.feature_class = feature_classes("gene")
    f.style = styles("dashes")
    giorgio.feature_style_configurations << f
    assert_equal giorgio.config.get_cstr("feature_styles","gene"),
                     "dashes"
  end

end
