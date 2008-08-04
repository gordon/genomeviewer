require File.dirname(__FILE__) + '/../test_helper'

class DrawingFormatConfigurationTest < ActiveSupport::TestCase

  fixtures :users
  
  def setup
    @u = users("a_test")
    @d = DrawingFormatConfiguration.new
    @u.drawing_format_configuration = @d    
  end
  
  def test_change_arrow_width
    assert_not_equal 10.0, @u.config.get_num("format","arrow_width")
    @d.arrow_width = 10
    @u.flush_config_cache
    assert_equal 10.0, @u.config.get_num("format","arrow_width")
  end
    
  def test_change_bar_height
    assert_not_equal 11.0, @u.config.get_num("format","bar_height")
    @d.bar_height = 11
    @u.flush_config_cache
    assert_equal 11.0, @u.config.get_num("format","bar_height")
  end

  def test_change_margins
    assert_not_equal 13.0, @u.config.get_num("format","margins")
    @d.margins = 13
    @u.flush_config_cache
    assert_equal 13.0, @u.config.get_num("format","margins")
  end
  
  def test_change_scale_arrow_height
    assert_not_equal 1.1, @u.config.get_num("format","scale_arrow_height")
    @d.scale_arrow_height = 1.1
    @u.flush_config_cache
    assert_equal 1.1, @u.config.get_num("format","scale_arrow_height")
  end

  def test_change_scale_arrow_width
    assert_not_equal 1.2, @u.config.get_num("format","scale_arrow_width")
    @d.scale_arrow_width = 1.2
    @u.flush_config_cache
    assert_equal 1.2, @u.config.get_num("format","scale_arrow_width")
  end
  
  def test_change_show_grid
    assert_not_equal "no", @u.config.get_cstr("format","show_grid")
    @d.show_grid = false
    @u.flush_config_cache
    assert_equal "no", @u.config.get_cstr("format","show_grid")
  end
  
  def test_change_stroke_width
    assert_not_equal 1.4, @u.config.get_num("format","stroke_width")
    @d.stroke_width = 1.4
    @u.flush_config_cache
    assert_equal 1.4, @u.config.get_num("format","stroke_width")
  end
  
  def test_change_min_len_block
    assert_not_equal 0.0, @u.config.get_num("format", "min_len_block")
    @d.min_len_block = 0.0
    @u.flush_config_cache
    assert_equal 0.0, @u.config.get_num("format", "min_len_block")
  end

end
