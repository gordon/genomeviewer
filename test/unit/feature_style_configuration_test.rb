require File.dirname(__FILE__) + '/../test_helper'

class FeatureStyleConfigurationTest < ActiveSupport::TestCase

  fixtures :users, :feature_classes, :styles
  
  def test_load_feature_styles
    u = users("a_test")
    assert_not_equal "dashes", u.config.get_cstr("feature_styles","gene")
    f = FeatureStyleConfiguration.new
    f.feature_class = feature_classes("gene")
    f.style = styles("dashes")
    u.feature_style_configurations << f
    u.flush_config_cache
    assert_equal "dashes", u.config.get_cstr("feature_styles","gene")
  end

end
