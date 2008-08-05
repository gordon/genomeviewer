require File.dirname(__FILE__) + '/../test_helper'

class FormatTest < ActiveSupport::TestCase

  fixtures :users
  
  def setup
    @user = users("a_test")
    @format = FormatTest.new
    @user.format_test = @format    
  end
  
  def test_change_arrow_width
    assert_not_equal 10.0, @user.config.get_num("format","arrow_width")
    @format.arrow_width = 10
    @user.flush_config_cache
    assert_equal 10.0, @user.config.get_num("format","arrow_width")
  end
    
  def test_change_bar_height
    assert_not_equal 11.0, @user.config.get_num("format","bar_height")
    @format.bar_height = 11
    @user.flush_config_cache
    assert_equal 11.0, @user.config.get_num("format","bar_height")
  end

  def test_change_margins
    assert_not_equal 13.0, @user.config.get_num("format","margins")
    @format.margins = 13
    @user.flush_config_cache
    assert_equal 13.0, @user.config.get_num("format","margins")
  end
  
  def test_change_scale_arrow_height
    assert_not_equal 1.1, @user.config.get_num("format","scale_arrow_height")
    @format.scale_arrow_height = 1.1
    @user.flush_config_cache
    assert_equal 1.1, @user.config.get_num("format","scale_arrow_height")
  end

  def test_change_scale_arrow_width
    assert_not_equal 1.2, @user.config.get_num("format","scale_arrow_width")
    @format.scale_arrow_width = 1.2
    @user.flush_config_cache
    assert_equal 1.2, @user.config.get_num("format","scale_arrow_width")
  end
  
  def test_change_show_grid
    assert_not_equal "no", @user.config.get_cstr("format","show_grid")
    @format.show_grid = false
    @user.flush_config_cache
    assert_equal "no", @user.config.get_cstr("format","show_grid")
  end
  
  def test_change_stroke_width
    assert_not_equal 1.4, @user.config.get_num("format","stroke_width")
    @format.stroke_width = 1.4
    @user.flush_config_cache
    assert_equal 1.4, @user.config.get_num("format","stroke_width")
  end
  
  def test_change_min_len_block
    assert_not_equal 0.0, @user.config.get_num("format", "min_len_block")
    @format.min_len_block = 0.0
    @user.flush_config_cache
    assert_equal 0.0, @user.config.get_num("format", "min_len_block")
  end

end
