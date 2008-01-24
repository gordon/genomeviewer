require File.dirname(__FILE__) + '/../test_helper'

class DrawingFormatConfigurationTest < ActiveSupport::TestCase

  fixtures :users
  
  def test_load_drawing_formats
    giorgio = users("giorgio")
    d = DrawingFormatConfiguration.new
    giorgio.drawing_format_configuration = d
    assert_not_equal giorgio.config.get_num("format","arrow_width"),
                            10.0
    d.arrow_width = 10
    assert_equal giorgio.config.get_num("format","arrow_width"),
                            10.0
    assert_not_equal giorgio.config.get_num("format","bar_height"),
                            11.0
    d.bar_height = 11
    assert_equal giorgio.config.get_num("format","bar_height"),
                            11.0
    assert_not_equal giorgio.config.get_num("format","margins"),
                            13.0
    d.margins = 13
    assert_equal giorgio.config.get_num("format","margins"),
                            13.0
    assert_not_equal giorgio.config.get_num("format","scale_arrow_height"),
                            1.1
    d.scale_arrow_height = 1.1
    assert_equal giorgio.config.get_num("format","scale_arrow_height"),
                            1.1
    assert_not_equal giorgio.config.get_num("format","scale_arrow_width"),
                            1.2
    d.scale_arrow_width = 1.2
    assert_equal giorgio.config.get_num("format","scale_arrow_width"),
                            1.2
    assert_not_equal giorgio.config.get_num("format","show_grid"),
                            0.0
    d.show_grid = false
    assert_equal giorgio.config.get_num("format","show_grid"),
                            0.0
    assert_not_equal giorgio.config.get_num("format","stroke_width"),
                            1.4
    d.stroke_width = 1.4
    assert_equal giorgio.config.get_num("format","stroke_width"),
                            1.4    
  end

end
