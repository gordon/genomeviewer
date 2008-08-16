require "test/test_helper.rb"
require File.dirname(__FILE__) + "/modules/gt_objects_assertions.rb"

class ColorTest < Test::Unit::TestCase
  
  include GTObjectsAssertions

  def test_constants
    assert Color.const_defined?("Channels")
  end

  def test_nof_arguments
    # must be 3
    assert_nothing_raised {Color.new(0.5, 0.5, 0.5)}
    [0,1,2,4].each do |n|
      args = [0.5]*n
      assert_raises(ArgumentError) {Color.new(*args)}
    end
  end
  
  def test_argument_range
    assert_nothing_raised {Color.new(0.0, 0.0, 0.0)}
    assert_nothing_raised {Color.new(0.1, 0.2, 0.3)}
    assert_nothing_raised {Color.new(1.0, 1.0, 1.0)}
    # underflow
    assert_raises(RangeError) {Color.new(-1.0, 0.0, 0.0)}
    assert_raises(RangeError) {Color.new(0.0, -1.0, 0.0)}
    assert_raises(RangeError) {Color.new(0.0, 0.0, -1.0)}
    # overflow
    assert_raises(RangeError) {Color.new(2.0, 1.0, 1.0)}
    assert_raises(RangeError) {Color.new(1.0, 2.0, 1.0)}
    assert_raises(RangeError) {Color.new(1.0, 1.0, 2.0)}
  end
  
  def test_argument_type
    # valid
    assert_nothing_raised {Color.new(1,1,1)}
    assert_nothing_raised {Color.new("0.5","0.5","0.5")}
    # undefined
    assert_equal Color.new(nil, nil, nil), Color.new(nil, nil, nil)
    # invalid => undefined
    assert_equal Color.new(nil, nil, nil), Color.new(1,1,"a")
  end
  
  # according to 
  # http://api.rubyonrails.org/classes/ActiveRecord/Aggregations/ClassMethods.html
  # aggregations (such as colors) should be value objects:
  #   => immutable 
  #   => equality defined as equality of its fields

  def test_immutable
    assert_raises(NoMethodError) {Color.new(0,0,0).red=0.5}
    assert_raises(NoMethodError) {Color.new(0,0,0).green=0.5}
    assert_raises(NoMethodError) {Color.new(0,0,0).blue=0.5}
  end
  
  def test_equality
    c1 = Color.new(0.0, 0.0, 0.0)
    assert_equal c1, c1
    c2 = Color.new(0.0, 0.0, 0.0)
    assert_not_equal c1.object_id, c2.object_id
    assert_equal c1, c2
    c3 = Color.new(1.0, 1.0, 1.0)
    assert_not_equal c1, c3
    assert_not_nil c1==c3
    assert_nil c1=="string"
    assert_not_equal c1, "string"
    # undefined are all equal to one another:
    assert_equal Color.new(nil, nil, nil), Color.new("a","b","c")
    assert_equal Color.new("","",""), Color.new(nil,[],{})
  end

  def test_conversion_to_gt_color
    gvc = Color.new(0.1, 0.2, 0.3)
    gtc = gvc.to_gt
    assert_gt_color gtc
    assert_equal gvc.red, gtc.red
    assert_equal gvc.green, gtc.green
    assert_equal gvc.blue, gtc.blue
    # undefined gt color
    assert_gt_color Color.new(nil,nil,nil).to_gt
  end
  
  def test_conversion_to_color
    [0,"a",{}].each {|x| assert_raises(ArgumentError) {Color(x)}}
    c1 = Color.new(0.1, 0.2, 0.3)
    assert_nothing_raised { Color(c1) }
    c2 = Color(c1)
    assert_not_equal c1.object_id, c2.object_id
    assert_equal c1, c2
  end

  def test_conversion_from_gt_color
    gtc = GTServer.color_new
    gtc.red = 0.1
    gtc.green = 0.2
    gtc.blue = 0.3
    gvc = Color(gtc)
    assert_equal gtc.red, gvc.red
    assert_equal gtc.green, gvc.green
    assert_equal gtc.blue, gvc.blue
  end
  
  def test_undefined
    assert !Color.new(1, 1, 1).undefined?
    assert Color.new(1, 1, nil).undefined?
    assert Color.new(nil, nil, nil).undefined?
    assert_equal Color.new(nil, nil, nil), Color.undefined
    assert Color.undefined.undefined?
  end
  
  def test_to_hex
    assert_equal '#001ACC', Color.new(0, 0.1, 0.8).to_hex
    assert_equal 'undefined', Color.new(nil, nil, nil).to_hex
  end
  
  def test_from_hex
    assert_equal Color.new(0, 0, 0), '#000000'.to_color
    assert_equal Color.new(0, 1, 1), '#00fFff'.to_color
    assert_equal Color.new(nil, nil, nil), '#00000'.to_color
    assert_equal Color.new(nil, nil, nil), '#0000000'.to_color
    assert_equal Color.new(nil, nil, nil), 'anything else'.to_color
  end
  
end
