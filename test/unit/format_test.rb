require File.dirname(__FILE__) + '/../test_helper'

class FormatTest < ActiveSupport::TestCase

  fixtures :users

  def setup
    user = users("a_test")
    user.reset_configuration
    @conf = user.configuration
    @format = @conf.format
    @a_color = Color.new(0.1,0.2,0.3)
    @a_float = 999.9
  end

  def test_section
    assert "format", @format.section
  end

  def test_attribute_lists
    # test one of the lists
    colors = [:track_title_color, :default_stroke_color]
    assert_equal colors, Format.list_colors
    # test global list
    require "set" # use Set as the sorting order is not important
    all = Format::ConfigTypes.map{|t| Format.send("list_#{t}")}.flatten
    assert_equal all.to_set, Format.configuration_attributes.to_set
  end

  def test_show_grid
    args = ["format","show_grid"]
    assert_equal @conf.gt.get_bool(*args), @format.default_show_grid
    assert_not_equal false, @format.show_grid
    assert_not_equal false, @conf.gt.get_bool(*args)
    @format.sync_show_grid = false
    assert_equal false, @format.show_grid
    assert_equal false, @conf.gt.get_bool(*args)
    @format.show_grid = true
    assert_equal true, @format.show_grid
    assert_equal false, @conf.gt.get_bool(*args)
    @format.upload_show_grid
    assert_equal true, @format.show_grid
    assert_equal true, @conf.gt.get_bool(*args)
  end

  def test_tests_will_be_defined
    assert Format.list_decimals.size > 0
    assert Format.list_colors.size > 0
  end

  Format.list_decimals.each do |f|
    define_method "test_#{f}" do
    args = ["format",f.to_s]
    assert_equal @conf.gt.get_num(*args), @format.send("default_#{f}")
    assert_not_equal @a_float, @format.send(f)
    assert_not_equal @a_float, @conf.gt.get_num(*args)
    @format.send("sync_#{f}=", @a_float)
    assert_in_delta @a_float, @format.send(f), 0.000000000001
    assert_equal @a_float, @conf.gt.get_num(*args)
    end
  end

  Format.list_colors.each do |col|
    define_method "test_#{col}" do
    args = ["format",col.to_s]
    assert_equal Color(@conf.gt.get_color(*args)),
                 @format.send("default_#{col}")
    assert_not_equal @a_color, @format.send(col)
    assert_not_equal @a_color, Color(@conf.gt.get_color(*args))
    @format.send("sync_#{col}=", @a_color)
    assert_equal @a_color, @format.send(col)
    assert_equal @a_color, Color(@conf.gt.get_color(*args))
    end
  end

end
