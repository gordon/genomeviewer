require File.dirname(__FILE__) + '/../test_helper'

class FeatureTypeTest < ActiveSupport::TestCase
  
  fixtures :users
  
  def setup
    user = users("a_test")
    user.reset_configuration
    @conf = user.configuration
    # reset gt config cache
    @conf.uncache
    @conf.gt
    @ft = FeatureType.create(:name => "a_test", :configuration_id => @conf.id)
    @conf.feature_types(true)
    @a_color = Color.new(0.1,0.2,0.3)
    @an_integer = 999
  end
  
  def test_uniqueness_validation
    assert !FeatureType.new(:name => "a_test", 
                            :configuration_id => @conf.id).valid?
    # uniqueness is defined in configuration_id scope:
    assert FeatureType.new(:name => "a_test", 
                           :configuration_id => (@conf.id)+1).valid?
  end

  def test_section
    assert "a_test", @ft.section
  end

  def test_attribute_lists
    # test one of the lists
    colors = [:fill, :stroke, :stroke_marked]
    assert_equal colors, FeatureType.list_colors
    # test global list
    require "set" # use Set as the sorting order is not important
    all = FeatureType::ConfigTypes.map{|t|FeatureType.send("list_#{t}")}.flatten
    assert_equal all.to_set, FeatureType.configuration_attributes.to_set
  end
  
  def test_tests_will_be_defined
    assert FeatureType.list_integers.size > 0
    assert FeatureType.list_colors.size > 0 
  end
  
  FeatureType.list_integers.each do |f|
    define_method "test_#{f}" do
      args = [@ft.section,f.to_s]
      assert_nil @ft.send("default_#{f}")
      assert_not_equal @an_integer, @ft.send(f)
      assert_not_equal @an_integer, @conf.gt.get_num(*args)
      @ft.send("sync_#{f}=", @an_integer)
      assert_equal @an_integer, @ft.send(f)
      assert_equal @an_integer, @conf.gt.get_num(*args)     
    end
  end

  FeatureType.list_colors.each do |col|
    define_method "test_#{col}" do
      args = [@ft.section,col.to_s]
      assert_equal Color.undefined, @ft.send("default_#{col}")
      assert_not_equal @a_color, @ft.send(col)
      assert_not_equal @a_color, Color(@conf.gt.get_color(*args))
      @ft.send("sync_#{col}=", @a_color)
      assert_equal @a_color, @ft.send(col)
      assert_equal @a_color, Color(@conf.gt.get_color(*args))
    end
  end
    
  def test_collapse_to_parent
    args = ["a_test","collapse_to_parent"]
    assert_equal @conf.gt.get_bool(*args), @ft.default_collapse_to_parent
    assert_not_equal true, @conf.gt.get_bool(*args)
    @ft.sync_collapse_to_parent = true
    assert_equal true, @ft.collapse_to_parent
    assert_equal true, @conf.gt.get_bool(*args)
  end

  def test_split_lines
    args = ["a_test","split_lines"]
    assert_equal @conf.gt.get_bool(*args), @ft.default_split_lines
    assert_not_equal true, @conf.gt.get_bool(*args)
    @ft.sync_split_lines = true
    assert_equal true, @ft.split_lines
    assert_equal true, @conf.gt.get_bool(*args)
  end

  def test_style
    args = ["a_test","style"]
    assert_equal @conf.gt.get_cstr(*args).to_style, @ft.default_style
    assert_not_equal "caret", @conf.gt.get_cstr(*args)
    @ft.sync_style = "caret".to_style 
    assert_equal "caret", @ft.style.string
    assert_equal "caret", @conf.gt.get_cstr(*args)
  end

end
