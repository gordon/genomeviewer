require File.dirname(__FILE__) + '/../test_helper'

class ColorConfigurationTest < ActiveSupport::TestCase

  fixtures :users,
             :feature_classes
  
  def test_load_color_configurations
    user = users("a_test")
    cc = ColorConfiguration.new
    cc.element = feature_classes("exon")
    cc.red = 0
    cc.green = 0.4
    cc.blue = 1
    assert_not_equal cc.red.to_f, user.config.get_color("exon").red
    assert_not_equal cc.green.to_f, user.config.get_color("exon").green
    assert_not_equal cc.blue.to_f, user.config.get_color("exon").blue    
    user.color_configurations << cc
    user.save
    user.flush_config_cache
    assert_equal cc.red.to_f, user.config.get_color("exon").red
    assert_equal cc.green.to_f, user.config.get_color("exon").green
    assert_equal cc.blue.to_f, user.config.get_color("exon").blue
  end

end
